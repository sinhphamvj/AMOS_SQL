#!/usr/bin/env python3
"""
Script Python tự động làm sạch dữ liệu CSV dựa trên schema database local
và sinh file SQL kết hợp lệnh \copy để import dữ liệu vào amos_db local.
"""

import os
import glob
import re
import csv
import io
import subprocess

def get_table_columns_info(tablename):
    """
    Lấy thông tin kiểu dữ liệu và ràng buộc NULL của các cột trong bảng từ database local.
    """
    cmd = [
        "psql", "-h", "localhost", "-U", "postgres", "-d", "amos_db",
        "-A", "-F", ",", "-c",
        f"SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_schema = 'amos' AND table_name = '{tablename}';"
    ]
    try:
        env = os.environ.copy()
        env["PGPASSWORD"] = "123456"
        result = subprocess.run(cmd, capture_output=True, text=True, env=env, check=True)
        
        # Làm sạch stdout: loại bỏ các cảnh báo WARNING, DETAIL, HINT và dòng tổng kết
        clean_lines = []
        header_found = False
        for line in result.stdout.splitlines():
            line = line.strip()
            if any(line.startswith(prefix) for prefix in ("WARNING:", "DETAIL:", "HINT:", "(")):
                continue
            if not line:
                continue
            if "column_name,data_type,is_nullable" in line:
                header_found = True
            if header_found:
                clean_lines.append(line)
                
        csv_data = "\n".join(clean_lines)
        reader = csv.DictReader(io.StringIO(csv_data))
        info = {}
        for row in reader:
            if not row.get("column_name") or not row.get("data_type"):
                continue
            info[row["column_name"]] = {
                "data_type": row["data_type"].lower(),
                "is_nullable": row["is_nullable"].upper() == "YES"
            }
        return info
    except Exception as e:
        print(f"   ⚠️ Không thể lấy thông tin schema cho bảng {tablename}: {e}")
        return None

def clean_csv_file(filepath):
    """
    Làm sạch file CSV:
    1. Xóa dấu nháy đơn phân cách hàng nghìn (ví dụ: 1'334 -> 1334)
    2. Điền giá trị phù hợp cho cột số (rỗng -> NULL) và cột chuỗi NOT NULL (rỗng -> khoảng trắng ' ')
    """
    tablename = os.path.splitext(os.path.basename(filepath))[0]
    schema_info = get_table_columns_info(tablename)
    
    if not schema_info:
        print(f"   ⚠️ Bỏ qua dọn dẹp nâng cao cho {tablename} do không lấy được schema.")
        return
        
    print(f"🧹 Đang làm sạch file: {os.path.basename(filepath)} dựa trên schema local...")
    try:
        # Đọc dữ liệu CSV gốc
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            reader = csv.reader(f)
            header = next(reader)
            rows = list(reader)
            
        cleaned_rows = []
        for row_idx, row in enumerate(rows):
            cleaned_row = []
            for col_idx, val in enumerate(row):
                if col_idx >= len(header):
                    cleaned_row.append(val)
                    continue
                col_name = header[col_idx]
                col_info = schema_info.get(col_name)
                
                # 1. Xóa dấu nháy đơn đứng giữa 2 chữ số (phân cách hàng nghìn)
                val_clean = re.sub(r"(\d)'(\d)", r"\1\2", val)
                
                # 2. Xử lý giá trị trống dựa trên kiểu dữ liệu và ràng buộc NOT NULL
                if col_info:
                    dtype = col_info["data_type"]
                    is_nullable = col_info["is_nullable"]
                    
                    if val_clean.strip() == "":
                        # Nếu là cột kiểu số/ngày tháng
                        if any(num_type in dtype for num_type in ("int", "double", "numeric", "real", "float", "decimal", "date", "time")):
                            val_clean = ""  # Để trống hoàn toàn -> Postgres sẽ nhận diện là NULL
                        # Nếu là cột kiểu chuỗi nhưng có ràng buộc NOT NULL
                        elif not is_nullable:
                            val_clean = " "  # Gán khoảng trắng đơn ' ' để thỏa mãn NOT NULL của Postgres
                        else:
                            val_clean = ""  # Cột chuỗi cho phép NULL -> chuyển thành rỗng
                cleaned_row.append(val_clean)
            cleaned_rows.append(cleaned_row)
            
        # Ghi đè lại file CSV đã dọn dẹp
        with open(filepath, 'w', encoding='utf-8', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(header)
            writer.writerows(cleaned_rows)
        print(f"   -> Làm sạch file {tablename}.csv hoàn tất.")
    except Exception as e:
        print(f"   ❌ Lỗi khi làm sạch file: {e}")

def main():
    # Cấu hình đường dẫn
    base_dir = "/home/sinh/Documents/AMOS_SQL/data_transfer"
    csv_dir = os.path.join(base_dir, "csv_data")
    sql_output = os.path.join(base_dir, "import_all.sql")
    
    # 1. Quét toàn bộ file CSV thực sự tồn tại trong thư mục csv_data
    csv_files = glob.glob(os.path.join(csv_dir, "*.csv"))
    if not csv_files:
        print(f"⚠️ Cảnh báo: Không tìm thấy bất kỳ file .csv nào trong thư mục: {csv_dir}")
        print("Vui lòng xuất dữ liệu từ DB thật và đặt các file CSV vào thư mục này trước khi chạy script.")
        return
        
    print(f"Tìm thấy {len(csv_files)} file CSV cần xử lý.")

    # 2. Làm sạch từng file CSV trước khi sinh SQL
    for filepath in csv_files:
        clean_csv_file(filepath)

    # 3. Sinh nội dung file SQL
    sql_lines = [
        "-- ================================================================================",
        "-- SCRIPT TỰ ĐỘNG IMPORT DỮ LIỆU AMOS VÀO DATABASE LOCAL (AMOS_DB)",
        f"-- Sinh tự động ngày: {os.popen('date').read().strip()}",
        "-- Chạy bằng lệnh: PGPASSWORD=123456 psql -h localhost -U postgres -d amos_db -f <đường_dẫn_file_này>",
        "-- ================================================================================",
        "",
        "SET search_path TO amos, public;",
        "",
        "-- [BƯỚC 1] Vô hiệu hóa tạm thời tất cả các ràng buộc khóa ngoại (FK) và trigger",
        "SET session_replication_role = 'replica';",
        "",
    ]
    
    # Gom tất cả lệnh TRUNCATE lên trước để tránh cascade xóa dữ liệu
    sql_lines.append("-- [BƯỚC 1.1] Truncate toàn bộ các bảng trước")
    for filepath in sorted(csv_files):
        tablename = os.path.splitext(os.path.basename(filepath))[0]
        sql_lines.append(f"TRUNCATE TABLE {tablename} CASCADE;")
    sql_lines.append("")
    
    # Thực hiện copy dữ liệu
    sql_lines.append("-- [BƯỚC 1.2] Copy dữ liệu từ CSV")
    for filepath in sorted(csv_files):
        filename = os.path.basename(filepath)
        tablename = os.path.splitext(filename)[0]
        abs_csv_path = os.path.abspath(filepath)
        sql_lines.append(f"-- Bảng: {tablename}")
        sql_lines.append(f"\\copy {tablename} FROM '{abs_csv_path}' WITH CSV HEADER DELIMITER ',' NULL '';")
        sql_lines.append("")
        
    sql_lines.extend([
        "-- [BƯỚC 2] Kích hoạt lại toàn bộ các ràng buộc khóa ngoại (FK) và trigger",
        "SET session_replication_role = 'origin';",
        "",
        "SELECT '✅ ĐÃ IMPORT THÀNH CÔNG TOÀN BỘ DỮ LIỆU!' AS status;"
    ])

    # 4. Ghi ra file SQL
    with open(sql_output, "w", encoding="utf-8") as f:
        f.write("\n".join(sql_lines))
        
    print(f"\n✅ Đã tạo file SQL import tại: {sql_output}")
    print("\nBạn có thể chạy câu lệnh sau trên terminal máy local để tiến hành import:")
    print("-" * 80)
    print(f"PGPASSWORD=123456 psql -h localhost -U postgres -d amos_db -f {sql_output}")
    print("-" * 80)

if __name__ == "__main__":
    main()
