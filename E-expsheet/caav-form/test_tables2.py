import docx

doc = docx.Document("11-2025 CAAV-FSSD Form 586 [2] 2021 AMT Log book CAT B2 VJC only.docx")
for idx, tbl in enumerate(doc.tables):
    if idx in [23, 25]:
        print(f"\n--- Table {idx} ---")
        for i, row in enumerate(tbl.rows[:5]):
            cells = [c.text.strip().replace('\n', ' ')[:30] for c in row.cells]
            print(f"Row {i}: {cells}")
