import docx

doc = docx.Document("11-2025 CAAV-FSSD Form 586 [2] 2021 AMT Log book CAT B2 VJC only.docx")
for idx, tbl in enumerate(doc.tables):
    if idx == 23:
        for i, row in enumerate(tbl.rows[:5]):
            unique_cells = []
            seen = set()
            for cell in row.cells:
                if cell._tc not in seen:
                    seen.add(cell._tc)
                    unique_cells.append(cell.text.strip().replace('\n', ' ')[:30])
            print(f"Row {i} ({len(unique_cells)} cols): {unique_cells}")
