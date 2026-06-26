#!/usr/bin/env python3
"""
Python port of the VBA macro `generateXFILE` (XFILE creator - Revision 52017,
Swiss Aviation Software) used to convert the Generic XFILE Generator .xlsm
template into a fixed-width .txt file for import into AMOS SQL.

Layout of the source worksheet (sheet 1):
  Row 1 : "Column Name"   (ignored)
  Row 2 : column headers   (ignored)
  Row 3 : column sizes     -> fixed width of each column in the output
  Row 4+: data rows

The macro writes columns B (col 2) through the last used column, rows 4 through
the last data row in column B. Every cell is right-padded with spaces to the
width given in row 3; the columns are concatenated with no separator and rows
are joined with CRLF, exactly as Excel/VBA would produce.

This reader parses the .xlsx/.xlsm XML directly (stdlib only) instead of using
openpyxl, because some files produced by recent Excel versions contain an
`extLst` element inside pattern fills that crashes openpyxl's stylesheet parser
(`PatternFill.__init__() got an unexpected keyword argument 'extLst'`). We only
need cell values, not styles, so we skip styles.xml entirely.

Truncate mode mirrors the VBA Yes/No prompt:
  - truncate=False : abort if any cell is longer than its allowed width
  - truncate=True  : cut overlong cells with Left() semantics

Usage:
  python3 generate_xfile.py INPUT.xlsm OUTPUT.txt [--truncate] [--sheet N]
"""

import argparse
import re
import sys
import unicodedata
import zipfile
from xml.etree import ElementTree as ET

# Explicit replacements for common "smart"/typographic characters that Excel
# inserts. AMOS reads the file as fixed-width *bytes*, so any non-ASCII char
# (which becomes 2-3 UTF-8 bytes) would push every following column out of
# alignment. We map them to a single ASCII byte each.
_ASCII_MAP = {
    " ": " ",   # non-breaking space
    " ": " ",   # figure space
    " ": " ",   # narrow no-break space
    "–": "-",   # en dash
    "—": "-",   # em dash
    "‒": "-",   # figure dash
    "‐": "-",   # hyphen
    "‑": "-",   # non-breaking hyphen
    "‘": "'",   # left single quote
    "’": "'",   # right single quote
    "“": '"',   # left double quote
    "”": '"',   # right double quote
    "…": "...",  # horizontal ellipsis
    "°": " ",   # degree sign -> space (no ASCII equivalent)
}


def to_ascii(text):
    """Collapse any non-ASCII character to a single ASCII byte so the output is
    pure ASCII and byte-for-byte aligned for AMOS fixed-width import.

    Strategy: explicit map first (handles smart punctuation cleanly), then NFKD
    normalization to strip accents (e.g. 'é' -> 'e'), then drop anything still
    non-ASCII, replacing it with '?' so width is preserved and the operator can
    spot it.
    """
    if not text:
        return text
    out = []
    for ch in text:
        if ord(ch) < 128:
            out.append(ch)
            continue
        if ch in _ASCII_MAP:
            out.append(_ASCII_MAP[ch])
            continue
        # Strip accents: 'é' -> 'e', 'ô' -> 'o', etc.
        decomposed = unicodedata.normalize("NFKD", ch)
        stripped = "".join(c for c in decomposed if ord(c) < 128 and not unicodedata.combining(c))
        out.append(stripped if stripped else "?")
    return "".join(out)

# OpenXML spreadsheet namespaces
NS_MAIN = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
NS_REL = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
NS_PKG_REL = "http://schemas.openxmlformats.org/package/2006/relationships"


def _q(ns, tag):
    return f"{{{ns}}}{tag}"


def _col_to_index(ref):
    """'B4' -> column index 2 (1-based). Letters part only."""
    letters = re.match(r"[A-Z]+", ref).group(0)
    idx = 0
    for ch in letters:
        idx = idx * 26 + (ord(ch) - ord("A") + 1)
    return idx


class Sheet:
    """Minimal sparse sheet: cells[(row, col)] = python value."""

    def __init__(self):
        self.cells = {}
        self.max_row = 0
        self.max_col = 0

    def value(self, row, col):
        return self.cells.get((row, col))


def _read_shared_strings(zf):
    if "xl/sharedStrings.xml" not in zf.namelist():
        return []
    root = ET.fromstring(zf.read("xl/sharedStrings.xml"))
    strings = []
    for si in root.findall(_q(NS_MAIN, "si")):
        # A string item may be a single <t> or several runs <r><t>..</t></r>.
        parts = [t.text or "" for t in si.iter(_q(NS_MAIN, "t"))]
        strings.append("".join(parts))
    return strings


def _first_sheet_path(zf):
    """Resolve the worksheet that appears first in the workbook (sheet 1 in VBA
    is ThisWorkbook.Worksheets(1) -> the first tab)."""
    wb = ET.fromstring(zf.read("xl/workbook.xml"))
    sheets_el = wb.find(_q(NS_MAIN, "sheets"))
    first = sheets_el.find(_q(NS_MAIN, "sheet"))
    rid = first.get(_q(NS_REL, "id"))

    rels = ET.fromstring(zf.read("xl/_rels/workbook.xml.rels"))
    for rel in rels.findall(_q(NS_PKG_REL, "Relationship")):
        if rel.get("Id") == rid:
            target = rel.get("Target")
            if not target.startswith("xl/"):
                target = "xl/" + target.lstrip("/")
            return target
    raise ValueError("Could not resolve first worksheet path.")


def _sheet_path_by_index(zf, index):
    wb = ET.fromstring(zf.read("xl/workbook.xml"))
    sheets = wb.find(_q(NS_MAIN, "sheets")).findall(_q(NS_MAIN, "sheet"))
    rid = sheets[index].get(_q(NS_REL, "id"))
    rels = ET.fromstring(zf.read("xl/_rels/workbook.xml.rels"))
    for rel in rels.findall(_q(NS_PKG_REL, "Relationship")):
        if rel.get("Id") == rid:
            target = rel.get("Target")
            if not target.startswith("xl/"):
                target = "xl/" + target.lstrip("/")
            return target
    raise ValueError(f"Could not resolve worksheet index {index}.")


def _parse_sheet(zf, path, shared):
    sheet = Sheet()
    root = ET.fromstring(zf.read(path))
    data = root.find(_q(NS_MAIN, "sheetData"))
    if data is None:
        return sheet

    for row_el in data.findall(_q(NS_MAIN, "row")):
        for c in row_el.findall(_q(NS_MAIN, "c")):
            ref = c.get("r")
            if not ref:
                continue
            row = int(re.search(r"\d+", ref).group(0))
            col = _col_to_index(ref)
            ctype = c.get("t", "n")  # default numeric

            value = None
            if ctype == "s":  # shared string
                v = c.find(_q(NS_MAIN, "v"))
                if v is not None and v.text is not None:
                    value = shared[int(v.text)]
            elif ctype == "inlineStr":
                is_el = c.find(_q(NS_MAIN, "is"))
                if is_el is not None:
                    value = "".join(t.text or "" for t in is_el.iter(_q(NS_MAIN, "t")))
            elif ctype == "str":  # formula result string
                v = c.find(_q(NS_MAIN, "v"))
                value = v.text if v is not None else None
            elif ctype == "b":  # boolean
                v = c.find(_q(NS_MAIN, "v"))
                value = (v is not None and v.text == "1")
            else:  # numeric (n) or date serial stored as number
                v = c.find(_q(NS_MAIN, "v"))
                if v is not None and v.text is not None:
                    num = float(v.text)
                    value = int(num) if num.is_integer() else num

            if value is not None and value != "":
                sheet.cells[(row, col)] = value
                if row > sheet.max_row:
                    sheet.max_row = row
                if col > sheet.max_col:
                    sheet.max_col = col
    return sheet


def load_first_sheet(input_path, sheet_index=None):
    with zipfile.ZipFile(input_path) as zf:
        shared = _read_shared_strings(zf)
        if sheet_index is None or sheet_index == 0:
            path = _first_sheet_path(zf)
        else:
            path = _sheet_path_by_index(zf, sheet_index)
        return _parse_sheet(zf, path, shared)


def flatten_whitespace(text):
    """Collapse in-cell line breaks and tabs to single spaces and trim.

    Excel cells can contain literal newlines (Alt+Enter), e.g.
    'ALTERNATE:\\nSUPPLEMENTARY LIFE RAFT'. In a fixed-width file each record
    must be exactly one line, so an embedded newline would split one record into
    two and shift everything after it. We replace any run of whitespace
    (newlines, tabs, multiple spaces) with a single space and strip the ends.
    """
    if not text:
        return text
    return re.sub(r"\s+", " ", text).strip()


def cell_to_str(value):
    """Render a cell the way VBA `Cells(i, j)` (as text) would, then flatten any
    in-cell line breaks to spaces and collapse to pure ASCII so each record is a
    single line and widths are measured in bytes the way AMOS reads them."""
    if value is None:
        return ""
    if isinstance(value, bool):
        return "True" if value else "False"
    if isinstance(value, float):
        s = str(int(value)) if value.is_integer() else repr(value)
    elif isinstance(value, int):
        s = str(value)
    else:
        s = str(value)
    return to_ascii(flatten_whitespace(s))


def find_last_column(sheet):
    """VBA Cells.Find(xlByColumns, xlPrevious) -> rightmost column with data."""
    last = 0
    for (r, c) in sheet.cells:
        if c > last:
            last = c
    return last


def find_last_row(sheet):
    """VBA Range("B65536").End(xlUp).Row -> last non-empty row in column B."""
    last = 0
    for (r, c) in sheet.cells:
        if c == 2 and r > last:
            last = r
    return last


def generate_xfile(input_path, output_path, truncate=False, sheet_index=0):
    sheet = load_first_sheet(input_path, sheet_index)

    last_col = find_last_column(sheet)
    last_row = find_last_row(sheet)

    if last_row < 4:
        raise ValueError("No data rows found (data starts at row 4).")

    lines = []
    for i in range(4, last_row + 1):          # VBA: For i = 4 To LastRow
        parts = []
        for j in range(2, last_col + 1):      # VBA: For j = 2 To LastColumn
            text = cell_to_str(sheet.value(i, j))
            length = len(text)
            allowed = sheet.value(3, j)
            allowed = int(allowed) if allowed is not None else 0
            space_target = allowed - length

            if space_target < 0:
                if not truncate:
                    header = cell_to_str(sheet.value(2, j))
                    raise ValueError(
                        f"Row {i}, column {j} ({header}): allowed range exceeded. "
                        f"Maximum allowed characters: {allowed}, but the cell "
                        f"contains: {length}.\n"
                        f"Re-run with --truncate to cut overlong cells."
                    )
                # VBA used Left(Cells(i, j), Length) which is a no-op bug; we cut
                # to the allowed width so the fixed-width output stays valid.
                text = text[:allowed]
            else:
                text = text + (" " * space_target)
            parts.append(text)
        lines.append("".join(parts))

    # VBA joins rows with vbNewLine (CRLF) and Print #1 adds a trailing newline.
    body = "\r\n".join(lines)
    # ASCII output: every char is exactly 1 byte, so the fixed-width layout AMOS
    # reads byte-by-byte stays aligned. cell_to_str() already guarantees ASCII.
    with open(output_path, "w", newline="", encoding="ascii") as f:
        f.write(body + "\r\n")

    print(f"Created {output_path}")
    print(f"  columns B..{last_col}, rows 4..{last_row}  ({len(lines)} lines)")
    print("  XFILE creator - Revision 52017 - Swiss Aviation Software")


def main():
    ap = argparse.ArgumentParser(description="Convert XFILE Generator .xlsm to fixed-width .txt for AMOS import.")
    ap.add_argument("input", help="input .xlsm file")
    ap.add_argument("output", help="output .txt file")
    ap.add_argument("--truncate", action="store_true",
                    help="truncate overlong cells instead of aborting (matches VBA 'Yes')")
    ap.add_argument("--sheet", type=int, default=0, help="worksheet index (default 0 = first sheet)")
    args = ap.parse_args()
    try:
        generate_xfile(args.input, args.output, truncate=args.truncate, sheet_index=args.sheet)
    except ValueError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
