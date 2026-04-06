import openpyxl
wb = openpyxl.load_workbook("KET_QUA_OJT_TASKS.xlsx")
ws = wb.active
for idx, row in enumerate(ws.iter_rows(values_only=True)):
    if idx == 0: continue
    empty_count = sum(1 for cell in row if not str(cell).strip() or str(cell) == "None")
    if empty_count > 1:  # ID is empty for everyone, so 1 empty is normal
        print(f"Row {idx+1}: {row}")
