import docx
doc = docx.Document("11-2025 CAAV-FSSD Form 586 [2] 2021 AMT Log book CAT B2 VJC only.docx")
table = doc.tables[23]
for i, row in enumerate(table.rows[:5]):
    cell = row.cells[0]
    print(f"Row {i} numId in xml: {'w:numId' in cell._tc.xml}, text: '{cell.text}'")
