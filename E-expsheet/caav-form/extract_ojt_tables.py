import os
import glob
import subprocess
import csv

try:
    import docx
    from docx.document import Document
    from docx.oxml.table import CT_Tbl
    from docx.oxml.text.paragraph import CT_P
    from docx.table import Table
    from docx.text.paragraph import Paragraph
except ImportError:
    print("Thư viện docx chưa được cài đặt. Đang tiến hành tự động cài đặt...")
    subprocess.check_call(["pip", "install", "python-docx", "--break-system-packages"])
    import docx
    from docx.document import Document
    from docx.oxml.table import CT_Tbl
    from docx.oxml.text.paragraph import CT_P
    from docx.table import Table
    from docx.text.paragraph import Paragraph

try:
    import openpyxl
except ImportError:
    print("Thư viện openpyxl chưa được cài đặt. Đang tiến hành tự động cài đặt...")
    subprocess.check_call(["pip", "install", "openpyxl", "--break-system-packages"])
    import openpyxl

FOLDER_PATH = "/home/sinh/Documents/AMOS_SQL/E-expsheet/caav-form"

def convert_doc_to_docx(doc_file_path):
    print(f"[*] Đang chuyển đổi chuẩn định dạng: {doc_file_path}")
    try:
        # Lệnh convert qua libreoffice
        subprocess.run(
            ['libreoffice', '--headless', '--convert-to', 'docx', doc_file_path, '--outdir', FOLDER_PATH],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        return doc_file_path + 'x'
    except Exception as e:
        print(f"[!] Lỗi khi convert {doc_file_path} - Cần cài đặt LibreOffice (sudo apt install libreoffice)")
        print(e)
        return None

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

def extract_ojt_table(docx_path):
    print(f"\n[+] ĐANG XỬ LÝ: {os.path.basename(docx_path)}")
    try:
        doc = docx.Document(docx_path)
    except Exception as e:
        print(f"[!] Lỗi đọc file: {e}")
        return []
    
    extracted_data = []
    last_para = ""
    
    # Quét tất cả các block (text và bảng) theo thứ tự
    for block in iter_block_items(doc):
        if isinstance(block, Paragraph):
            text = block.text.strip()
            if text:
                last_para = text
                
        elif isinstance(block, Table):
            # Kiểm tra xem có phải bảng Example không (bảng đứng ngay sau đoạn có chữ Example)
            if last_para.lower().startswith('example'):
                print("    -> [SKIPPED] Bỏ qua bảng Example.")
                continue
            
            # Kiểm tra text ở 3 dòng đầu xem có đúng bảng OJT không 
            header_text = ""
            for row in block.rows[:3]:
                for cell in row.cells:
                    header_text += cell.text.lower()
                    
            if 'task description' in header_text and 'task reference' in header_text:
                print("    -> Đã tìm thấy bảng OJT Tasks! Đang đọc 4 cột đầu tiên...")
                
                task_id_counter = 1
                # Lặp qua các dòng để trích xuất
                for row in block.rows:
                    unique_cells = []
                    seen = set()
                    for cell in row.cells:
                        if cell._tc not in seen:
                            seen.add(cell._tc)
                            unique_cells.append(cell.text.strip().replace('\n', ' '))
                    
                    # Bỏ qua các dòng trống hoàn toàn
                    if not any(unique_cells):
                        continue
                        
                    # Lọc bỏ các dòng chứa Text tiêu đề (Header rows)
                    first_col = unique_cells[0].lower()
                    
                    # Lấy đủ 4 cột đầu, nếu dòng có ít cột thì thêm rỗng
                    while len(unique_cells) < 4:
                        unique_cells.append("")
                        
                    if 'id' in first_col or '1.' in first_col or 'cat' in unique_cells[3].lower():
                        continue 
                        
                    # Chỉ lấy các dòng có dữ liệu ở cả cột 2, 3, 4
                    if not unique_cells[1].strip() or not unique_cells[2].strip() or not unique_cells[3].strip():
                        continue
                        
                    # Gán Auto Number ID nếu cột 1 trống (do định dạng list tự động của Word)
                    if not unique_cells[0].strip():
                        unique_cells[0] = str(task_id_counter)
                    
                    task_id_counter += 1
                        
                    # Lấy 4 cột đầu tiên
                    extracted_data.append(unique_cells[:4])
                    
    if not extracted_data:
        print("    -> [SKIPPED] KHÔNG TÌM THẤY DỮ LIỆU BẢNG OJT NÀO TRONG FILE NÀY!")
        
    return extracted_data

def main():
    os.chdir(FOLDER_PATH)
    
    # Quét các file .doc gốc
    doc_files = glob.glob("*.doc")
    pure_doc_files = [f for f in doc_files if not f.endswith('x')]
    
    all_rows = []
    
    for doc_file in pure_doc_files:
        docx_file = doc_file + 'x'
        
        # Chuyển đổi .doc sang .docx nếu chưa có
        if not os.path.exists(docx_file):
            convert_doc_to_docx(doc_file)
            
        if os.path.exists(docx_file):
            data = extract_ojt_table(docx_file)
            for row in data:
                # Thêm Tên File ở cột đầu để phân biệt record của file nào
                all_rows.append([doc_file] + row)
                
    # Ghi toàn bộ dữ liệu ra cục bộ file Excel
    excel_file = "KET_QUA_OJT_TASKS.xlsx"
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "OJT Tasks"
    
    # 5 Cột: Source_File + 4 cột trong bảng OJT (ID, Task description, Task reference, CAT)
    headers = [
        "Source_File", "ID", "Task description", "Task reference", "CAT"
    ]
    ws.append(headers)
    for row in all_rows:
        ws.append(row)
        
    wb.save(excel_file)
        
    print(f"\n✅ [HOÀN THÀNH] Trích xuất thành công! Dữ liệu đã được lưu vào file Excel: {os.path.join(FOLDER_PATH, excel_file)}")

if __name__ == '__main__':
    main()
