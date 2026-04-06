import docx
import glob

for f in glob.glob("*.docx"):
    print(f"\n--- {f} ---")
    doc = docx.Document(f)
    table_index = 0
    for tbl in doc.tables:
        cols = len(tbl.columns)
        first_row_text = ""
        try:
            first_row_text = tbl.rows[0].cells[0].text[:30].replace('\n', ' ')
        except Exception:
            pass
        print(f"Table {table_index}: cols={cols}, first_row='{first_row_text}'")
        table_index += 1
