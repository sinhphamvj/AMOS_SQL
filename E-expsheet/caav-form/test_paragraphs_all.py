import docx
import glob
from docx.document import Document
from docx.oxml.table import CT_Tbl
from docx.oxml.text.paragraph import CT_P
from docx.table import Table
from docx.text.paragraph import Paragraph

def iter_block_items(parent):
    if isinstance(parent, Document):
        parent_elm = parent.element.body
    else:
        parent_elm = parent._element
    for child in parent_elm.iterchildren():
        if isinstance(child, CT_P):
            yield Paragraph(child, parent)
        elif isinstance(child, CT_Tbl):
            yield Table(child, parent)

for f in glob.glob("*.docx"):
    print(f"--- {f} ---")
    doc = docx.Document(f)
    last_para = ""
    for block in iter_block_items(doc):
        if isinstance(block, Paragraph):
            text = block.text.strip()
            if text:
                last_para = text
        elif isinstance(block, Table):
            if len(block.columns) == 10:
                print("  Found 10-col table. Last para:", last_para)
