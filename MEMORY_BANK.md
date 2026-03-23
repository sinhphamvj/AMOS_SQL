# 🧠 Memory Bank - Kiến thức từ Phân tích Queries

File này lưu trữ các insights và kiến thức quan trọng được rút ra từ việc phân tích **131 file SQL** trong các thư mục con.

**Cập nhật lần cuối**: Từ phân tích queries thực tế

---

## 📊 Thống kê Tổng quan

- **Tổng số file SQL phân tích**: 131 files
- **Số bảng unique được sử dụng**: 103 tables
- **Bảng được sử dụng nhiều nhất**: `wo_header` (140 lần)

---

## 🏆 Top 10 Bảng Thường Dùng Nhất

Dựa trên phân tích tần suất sử dụng trong queries thực tế:

| # | Bảng | Số lần sử dụng | Mô tả |
|---|------|----------------|-------|
| 1 | `wo_header` | 140 | Header của Work Order/Jobcard - Bảng quan trọng nhất |
| 2 | `sign` | 109 | Thông tin nhân viên - Rất thường dùng |
| 3 | `wp_header` | 93 | Header của Work Package |
| 4 | `workstep_link` | 73 | Link workstep - Kết nối WO với description |
| 5 | `wo_text_description` | 65 | Mô tả của WO |
| 6 | `address` | 61 | Address/Vendor master |
| 7 | `wp_assignment` | 51 | Assignment của Work Package |
| 8 | `wo_header_more` | 44 | Thông tin bổ sung của WO |
| 9 | `event_template` | 41 | Template revision |
| 10 | `work_template` | 28 | Template của Work Order/Jobcard |

**Kết luận**: Khi tạo query, ưu tiên index và hiểu rõ các bảng này trước.

---

## 📋 Top Bảng với Nhiều Columns Được Sử Dụng

Các bảng có nhiều columns được sử dụng trong queries thực tế:

| Bảng | Số columns | Mô tả |
|------|------------|-------|
| `wp_header` | 114 | Work Package header - Rất nhiều thông tin |
| `forecast` | 93 | Forecast maintenance |
| `part_forecast` | 83 | Part forecast |
| `wo_transfer` | 48 | WO transfer |
| `address` | 33 | Address/Vendor |
| `forecast_dimension` | 32 | Forecast dimension |
| `wo_header_4` | 24 | WO header extension 4 |
| `wp_history` | 24 | WP history |
| `wo_text_action` | 23 | WO text action |
| `pickslip_detail` | 23 | Pickslip detail |

**Kết luận**: Các bảng này có nhiều columns quan trọng, cần tra cứu kỹ khi sử dụng.

---

## 🔑 Columns Thường Dùng Theo Bảng

### `wo_header` (19 columns thường dùng)
- `event_perfno_i` - PK, identifier
- `ac_registr` - Mã máy bay
- `state` - Trạng thái ('O', 'C')
- `type` - Loại WO
- `event_type` - Loại event
- `issue_date` - Ngày issue (DATE_INT)
- `issue_station` - Station issue
- `closing_date` - Ngày đóng (DATE_INT)
- `workorderno_display` - Số WO hiển thị
- `template_revisionno_i` - Link đến template
- `ata_chapter` - ATA chapter
- `mel_code` - MEL code
- `hil` - Hold Item List
- `mech_sign` - Mechanic sign
- `release_station` - Release station
- `release_time` - Release time
- `projectno` - Project number
- `prio` - Priority
- `psn` - Component PSN

### `wp_header` (114 columns - Top columns)
- `wpno_i` - PK
- `wpno` - WP number
- `ac_registr` - Aircraft registration
- `ac_typ` - Aircraft type
- `station` - Station
- `state` - State
- `status` - Status
- `start_date`, `start_time` - Start (DATE_INT)
- `end_date`, `end_time` - End (DATE_INT)
- `act_start_date`, `act_start_time` - Actual start
- `act_end_date`, `act_end_time` - Actual end
- `est_start_date`, `est_start_time` - Estimated start
- `est_end_date`, `est_end_time` - Estimated end
- `est_groundtime` - Estimated groundtime
- `target_start_date`, `target_start_time` - Target start
- `target_end_date`, `target_end_time` - Target end
- `inbound_scheduled_date`, `inbound_scheduled_time` - Inbound scheduled
- `closing_date` - Closing date
- `wp_type` - WP type
- `wp_status` - WP status
- `remarks` - Remarks
- `projectno` - Project number
- `created_date` - Created date (DATE_INT)
- `created_by` - Created by
- `mutation` - Mutation date (DATE_INT)
- `mutator` - Mutator

### `pickslip_header` (15 columns thường dùng)
- `pickslipno` - Pickslip number
- `issue_date` - Issue date (DATE_INT)
- `station_to` - Station to
- `station_from` - Station from
- `status` - Status
- `event_key` - Event key
- `created_date` - Created date (DATE_INT)
- `remarks` - Remarks
- `store_to` - Store to
- `pickslip_date` - Pickslip date (DATE_INT)
- `event_type` - Event type
- `mech_sign` - Mechanic sign
- `receiver` - Receiver

---

## 🎯 Patterns Quan Trọng Từ Queries Thực Tế

### 1. Join Pattern: WO với Description
```sql
-- Pattern thường dùng: Lấy description mới nhất của WO
LEFT JOIN workstep_link wl ON wo.event_perfno_i = wl.event_perfno_i
    AND wl.sequenceno = (
        SELECT MAX(sequenceno) 
        FROM workstep_link wl2 
        WHERE wl2.event_perfno_i = wo.event_perfno_i
    )
LEFT JOIN wo_text_description wo_desc ON wl.descno_i = wo_desc.descno_i
```

### 2. Jobcard Pattern: Parse WO từ Jobcard Name
```sql
-- Jobcard name format: JC-AXXX-YYYYYYYYY
-- Parse WO number (YYYYYYYYY) từ template_number
CAST(NULLIF(SPLIT_PART(template_number, '-', 3), '') AS INTEGER) AS extracted_wono
```

### 3. Date Filter Pattern: DATE_INT Comparison
```sql
-- So sánh DATE_INT (không dùng hàm convert)
WHERE created_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval 'N days')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date)
```

### 4. Station Filter Pattern
```sql
-- Filter theo nhiều stations
WHERE station_from IN ('SGN', 'HAN', 'DAD', 'CXR', 'HPH', 'VCA', 'PQC', 'VII', 'VTE')
```

### 5. Status Filter Pattern
```sql
-- Filter theo status (thường là 0, 1, 2, 4)
WHERE status IN (0, 1, 2, 4)
```

---

## 💡 Insights Quan Trọng

### 1. Ưu tiên Index các Bảng Thường Dùng
- Khi tạo query mới, ưu tiên sử dụng các bảng trong Top 10
- Các bảng này đã được index và có nhiều ví dụ trong queries thực tế

### 2. Columns Thường Dùng
- Mỗi bảng có một số columns được sử dụng nhiều hơn
- Ưu tiên tra cứu các columns này trước khi tìm các columns khác

### 3. Join Patterns
- Có các pattern join phổ biến (WO + description, WP + assignment, etc.)
- Sử dụng lại các pattern này để đảm bảo tính nhất quán

### 4. Date Handling
- DATE_INT là format chính, không dùng hàm convert
- Pattern so sánh DATE_INT đã được chuẩn hóa

### 5. Station Codes
- Các station codes thường dùng: SGN, HAN, DAD, CXR, HPH, VCA, PQC, VII, VTE
- Thường filter theo danh sách stations

---

## 📚 Files Tham Khảo

- **[QUERY_TABLE_COLUMN_USAGE.md](./QUERY_TABLE_COLUMN_USAGE.md)** ⭐⭐⭐ - Phân tích chi tiết từ 131 queries
- **[COLUMN_INDEX.md](./COLUMN_INDEX.md)** ⭐⭐ - Index columns với thông tin từ queries thực tế
- **[SCHEMA_INDEX.md](./SCHEMA_INDEX.md)** ⭐ - Index 2,141 bảng
- **[TABLE_REFERENCE.md](./TABLE_REFERENCE.md)** - Tham chiếu bảng chính
- **[QUERY_PATTERNS.md](./QUERY_PATTERNS.md)** - Patterns query thường dùng

---

## ⚠️ Lỗi thường gặp & Cách sửa

### 1. `wp_header` KHÔNG có cột `state`
- **Lỗi**: `column wp_header.state does not exist`
- **Nguyên nhân**: Cột `state = 'O'/'C'` thuộc về `wo_header`, không phải `wp_header`
- **Sửa**: Dùng `wp_header.status <> 9` để loại bỏ WP đã xoá (status = 9 = deleted)

### 2. SQL-Central AMOS không hỗ trợ comment ở đầu query
- **Lỗi**: `A batch has to begin with a select/update/insert/delete-command`
- **Nguyên nhân**: Query bắt đầu bằng `--` comment thay vì lệnh SQL
- **Sửa**: Xoá tất cả comment `--` hoặc `/* */` ở trước câu lệnh `SELECT`

### 3. Header của Daily Check WO
- **Sai**: `wo_text_description.header LIKE 'PERFORM CHECK: DAILY CHECK-A320/A321%'`
- **Sai**: `wo_text_description.header = 'DAILY CHECK-A320/A321'`
- **Đúng**: `wo_text_description.header = 'DAILY CHECK'`
- **Lý do**: Header thực tế trong DB chỉ là `'DAILY CHECK'`, phần chi tiết nằm trong cột `text` (vd: `'PERFORM DAILY CHECK IAW FORM EPF108.'`)

### 4. AMOS Report Designer tự đổi dấu nháy đơn `'` thành backtick `` ` ``
- **Lỗi**: `Unterminated string literal started at position X in SQL SELECT`
- **Nguyên nhân**: AMOS Report Designer khi paste SQL tự chuyển `'` → `` ` `` — PostgreSQL không nhận backtick làm string delimiter
- **Sửa**: Sau khi paste vào Report Designer, dùng Find & Replace đổi tất cả `` ` `` → `'`
- **Dấu hiệu nhận biết**: Trong error log thấy `` DATE `1971-12-31` `` thay vì `DATE '1971-12-31'`

### 5. `OutOfMemoryError: Java heap space` khi chạy query không có bộ lọc
- **Lỗi**: `java.lang.OutOfMemoryError: Java heap space` trong AMOS Java client
- **Nguyên nhân**: Query không có bộ lọc ngày hoặc ground time → trả về toàn bộ lịch sử WP (hàng chục ngàn bản ghi) → AMOS client hết bộ nhớ heap
- **Sửa**: Luôn thêm bộ lọc ngày để giới hạn kết quả. Ví dụ lọc hôm qua đến hôm nay:
  ```sql
  AND wp_header.start_date >= ((current_timestamp::date - interval '1 day')::date - '1971-12-31'::date)
  AND wp_header.start_date <= (current_timestamp::date - '1971-12-31'::date)
  ```
- **Lưu ý**: Bộ lọc ngày cho `wp_header` cần chuyển đổi theo công thức `date - '1971-12-31'::date` vì ngày lưu dạng INTEGER trong AMOS

---

## 🔄 Cập nhật

File này sẽ được cập nhật khi:
- Có thêm queries mới được phân tích
- Phát hiện patterns mới
- Có insights mới từ việc sử dụng queries

**Lần cập nhật cuối**: Thêm lỗi #5 OutOfMemoryError và cách fix bộ lọc ngày cho `wp/check_wp_missing_daily_check.sql`

