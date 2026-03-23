# 📚 AMOS SQL Queries Repository

Kho lưu trữ các câu truy vấn SQL cho hệ thống AMOS (Aircraft Maintenance and Operations System) của Vietjet Air.

## 📁 Cấu trúc thư mục

### 📊 Báo cáo và Dashboard
- **`daily report/`** - Các query báo cáo hàng ngày
- **`dashboard/`** - Query cho dashboard monitoring
- **`DLYWP_DB/`** - Query database Work Package hàng ngày

### 🔧 Quản lý Bảo trì
- **`maint_control/`** - Kiểm soát bảo trì (7D WO, Next Due, etc.)
- **`wp/`** - Work Package queries (34 files)
- **`ADD_SHEET/`** - Queries liên quan đến ADD Sheet, MEL, OPS

### 👥 Nhân sự và Tài nguyên
- **`staff/`** - Quản lý nhân viên, PQS, user
- **`resource/`** - Quản lý tài nguyên theo station (SGN, HAN, DAD, HPH, VCA, etc.)

### 🔩 Phụ tùng và Kho
- **`part_pooling/`** - Quản lý pooling phụ tùng
- **`part_hangar/`** - Quản lý phụ tùng trong hangar

### 📄 Schema
- **`vietjet_amos_schema.sql`** - Schema đầy đủ của database AMOS (71,000+ dòng)
- **`SCHEMA_INDEX.md`** ⭐ - Index tra cứu nhanh tất cả 2,141 bảng theo chức năng

### 📚 Reference Queries
- **`reference_queries/`** - Các query mẫu đã được xác nhận chính xác (dùng làm reference)

### 📝 E-Expansion Sheet
- **`E-expsheet/`** - Queries cho các biểu mẫu CAAV/FSSD (PEL 542, FSSD 008)

### 📦 Khác
- **`backup/`** - Backup các query cũ

## 🔍 Tìm kiếm nhanh

### Theo chức năng
Xem file [INDEX.md](./INDEX.md) để tìm query theo chức năng cụ thể.

### Theo bảng database
- Xem file [QUERY_TABLE_COLUMN_USAGE.md](./QUERY_TABLE_COLUMN_USAGE.md) ⭐⭐⭐ để xem phân tích table/column từ 131 queries thực tế
- Xem file [MEMORY_BANK.md](./MEMORY_BANK.md) ⭐⭐ để xem kiến thức và insights từ phân tích queries
- Xem file [SCHEMA_INDEX.md](./SCHEMA_INDEX.md) ⭐ để tra cứu nhanh tất cả 2,141 bảng
- Xem file [COLUMN_INDEX.md](./COLUMN_INDEX.md) ⭐⭐ để tra cứu chi tiết column của các bảng quan trọng
- Xem file [TABLE_REFERENCE.md](./TABLE_REFERENCE.md) để biết các bảng chính và cách sử dụng

### Theo pattern
Xem file [QUERY_PATTERNS.md](./QUERY_PATTERNS.md) để xem các pattern query thường dùng.

## 📋 Các bảng chính

### Work Order & Jobcard
- `wo_header` - Header của Work Order/Jobcard
- `wo_header_more` - Thông tin bổ sung của WO
- `wo_text_description` - Mô tả WO
- `wo_text_action` - Action của WO
- `work_template` - Template của Work Order/Jobcard
- `event_template` - Template revision

### Work Package
- `wp_header` - Header của Work Package
- `wp_history` - Lịch sử WP

### Phụ tùng
- `wo_part_on_off` - Part on/off trong WO
- `pickslip` - Pickslip

### Nhân sự
- `sign` - Thông tin nhân viên
- `staff_pqs_qualification` - PQS qualification

### Liên kết
- `db_link` - Liên kết giữa các entity (WO, Jobcard, etc.)

## 🎯 Các query thường dùng

### Jobcard
- Lấy jobcard: `reference_queries/get_all_jobcards.sql` ⭐ (Query Reference)
- Jobcard có WO đã đóng: Xem `reference_queries/get_all_jobcards.sql` ⭐
- Jobcard có WO đã đóng + REPETITIVE INSPECTION: Xem `exc_query.sql`

### Work Order
- WO đang mở: Xem `daily report/wooverdue.sql`
- WO đã đóng: Xem `daily report/woclosedbyAM.sql`
- WO AOG: Xem `daily report/get_wo_aog.sql`

### Work Package
- WP theo station: Xem `wp/`
- WP statistics: Xem `DLYWP_DB/`

### Resource
- Resource theo station: Xem `resource/`
- Resource dashboard: Xem `resource/*_DASHBOARD/`

## 💡 Lưu ý quan trọng

### Xử lý ngày tháng AMOS
AMOS sử dụng định dạng ngày đặc biệt (DATE_INT):
- Mốc ngày: `1971-12-31`
- Số ngày từ mốc được lưu dưới dạng INTEGER

**So sánh DATE_INT (khuyến nghị):**
```sql
-- Lọc từ hôm qua đến hôm nay
WHERE created_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval '1 day')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date)
```

**Hiển thị DATE_INT:**
```sql
-- Chuyển đổi để hiển thị
SELECT (DATE '1971-12-31' + date_column)::DATE AS display_date
```

**Lưu ý**: Không sử dụng hàm `amos_to_date()` trong query vì AMOS không hỗ trợ

### Các loại Work Order
- **Work Order**: `type IN ('M', 'P', 'C', 'S')` và `workorderno_display IS NOT NULL`
- **Jobcard**: `event_type = 'JC'`, `type = 'PD'`, `workorderno_display IS NULL`
- **Event Pending**: `type = 'PD'`, `workorderno_display IS NULL`

### Tên Jobcard
- Format: `JC-AXXX-YYYYYYYYY`
  - `AXXX`: Mã máy bay (ac_registr)
  - `YYYYYYYYY`: event_perfno_i của WO
- Lưu trong: `work_template.template_number` với `template_type = 'J'`

## 📚 Schema Database

File **`vietjet_amos_schema.sql`** chứa toàn bộ schema của database AMOS:
- Tất cả các bảng và cột
- Comments mô tả chi tiết
- Indexes và constraints

Sử dụng file này để:
- Tìm cấu trúc bảng khi viết query
- Hiểu mối quan hệ giữa các bảng
- Tham khảo data types và constraints

## 📝 Quy ước đặt tên file

- File SQL: `.sql` (lowercase)
- File SQL lớn: `.SQL` (uppercase) - thường là stored procedure
- Tên file mô tả chức năng: `get_*.sql`, `check_*.sql`, `*_list.sql`, `*_statistics.sql`

## 🔄 Cập nhật

Khi thêm query mới:
1. Đặt vào thư mục phù hợp
2. Đặt tên file mô tả rõ chức năng
3. Thêm comment trong file giải thích query
4. Cập nhật INDEX.md nếu cần

---

**Lưu ý**: Đây là kho lưu trữ nội bộ Vietjet Air. Sử dụng cho mục đích công việc.

