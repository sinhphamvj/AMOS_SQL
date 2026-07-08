-- ================================================================================
-- SCRIPT TỰ ĐỘNG IMPORT DỮ LIỆU AMOS VÀO DATABASE LOCAL (AMOS_DB)
-- Sinh tự động ngày: Wed Jul  1 04:22:29 PM +07 2026
-- Chạy bằng lệnh: PGPASSWORD=123456 psql -h localhost -U postgres -d amos_db -f <đường_dẫn_file_này>
-- ================================================================================

SET search_path TO amos, public;

-- [BƯỚC 1] Vô hiệu hóa tạm thời tất cả các ràng buộc khóa ngoại (FK) và trigger
SET session_replication_role = 'replica';

-- [BƯỚC 1.1] Truncate toàn bộ các bảng trước
TRUNCATE TABLE aircraft CASCADE;
TRUNCATE TABLE sign CASCADE;
TRUNCATE TABLE staff_pqs_class CASCADE;
TRUNCATE TABLE staff_pqs_qualification CASCADE;
TRUNCATE TABLE staff_pqs_type CASCADE;

-- [BƯỚC 1.2] Copy dữ liệu từ CSV
-- Bảng: aircraft
\copy aircraft FROM '/home/sinh/Documents/AMOS_SQL/data_transfer/csv_data/aircraft.csv' WITH CSV HEADER DELIMITER ',' NULL '';

-- Bảng: sign
\copy sign FROM '/home/sinh/Documents/AMOS_SQL/data_transfer/csv_data/sign.csv' WITH CSV HEADER DELIMITER ',' NULL '';

-- Bảng: staff_pqs_class
\copy staff_pqs_class FROM '/home/sinh/Documents/AMOS_SQL/data_transfer/csv_data/staff_pqs_class.csv' WITH CSV HEADER DELIMITER ',' NULL '';

-- Bảng: staff_pqs_qualification
\copy staff_pqs_qualification FROM '/home/sinh/Documents/AMOS_SQL/data_transfer/csv_data/staff_pqs_qualification.csv' WITH CSV HEADER DELIMITER ',' NULL '';

-- Bảng: staff_pqs_type
\copy staff_pqs_type FROM '/home/sinh/Documents/AMOS_SQL/data_transfer/csv_data/staff_pqs_type.csv' WITH CSV HEADER DELIMITER ',' NULL '';

-- [BƯỚC 2] Kích hoạt lại toàn bộ các ràng buộc khóa ngoại (FK) và trigger
SET session_replication_role = 'origin';

SELECT '✅ ĐÃ IMPORT THÀNH CÔNG TOÀN BỘ DỮ LIỆU!' AS status;