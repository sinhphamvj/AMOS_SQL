# 🔍 Reference Queries Index - Chỉ mục Query Mẫu

Index chi tiết các query reference để tìm kiếm nhanh và chính xác.

## 📋 Jobcard Queries

### get_all_jobcards.sql
**File**: `reference_queries/get_all_jobcards.sql`

**Mô tả**: Query mẫu chính xác để lấy jobcard có WO đã đóng trong khoảng thời gian

**Keywords/Từ khóa**:
- jobcard, JC
- jobcard có WO đã đóng
- parse WO từ jobcard
- jobcard template
- WO đóng trong N ngày
- closing_date filter

**Pattern sử dụng**:
1. Parse WO number từ template_number: `SPLIT_PART(template_number, '-', 3)`
2. Join với WO đã đóng: `wo.state = 'C'`
3. Lọc theo thời gian: `closing_date BETWEEN ...`
4. Join với jobcard instance: `jc.template_revisionno_i = t.wtno_i`

**Các biến thể có thể**:
- Thay đổi số ngày: Sửa `'30 days'` thành số ngày khác
- Thêm điều kiện lọc WO: Thêm vào WHERE của join với `wo`
- Thêm điều kiện lọc jobcard: Thêm vào WHERE của join với `jc`
- Thêm join với bảng khác: Thêm LEFT JOIN sau join với `jc`

**Ví dụ sử dụng**:
```sql
-- Lấy jobcard có WO đã đóng trong 7 ngày
-- Copy từ get_all_jobcards.sql và thay '30 days' thành '7 days'

-- Lấy jobcard có WO đã đóng trong 1 năm
-- Copy từ get_all_jobcards.sql và thay '30 days' thành '365 days'

-- Lấy jobcard có WO đã đóng + có "REPETITIVE INSPECTION"
-- Copy từ get_all_jobcards.sql và thêm join với wo_text_description
```

## 📋 Pickslip Queries

### example_pickslip_yesterday_to_today.sql
**File**: `reference_queries/example_pickslip_yesterday_to_today.sql`

**Mô tả**: Ví dụ mẫu về cách lọc pickslip theo ngày trong AMOS

**Keywords/Từ khóa**:
- pickslip
- lọc pickslip theo ngày
- pickslip từ hôm qua đến hôm nay
- pickslip trong N ngày
- created_date filter
- DATE_INT filter
- lọc theo khoảng thời gian

**Pattern sử dụng**:
1. Lọc theo created_date: `created_date BETWEEN ...`
2. Sử dụng pattern AMOS DATE_INT: `(current_timestamp::date - '1971-12-31'::date)`
3. Join với pickslip_detail, od_detail, od_header
4. Lọc theo station và status

**Pattern chính**:
```sql
-- Lọc từ hôm qua đến hôm nay
AND pickslip_header.created_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval '1 day')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date)

-- Lọc từ N ngày trước đến hôm nay (thay '1 day' thành 'N days')
AND pickslip_header.created_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval 'N days')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date)
```

**Các biến thể có thể**:
- Thay đổi số ngày: Sửa `'1 day'` thành số ngày mong muốn
- Thay đổi cột ngày: Thay `created_date` bằng `issue_date` hoặc cột DATE_INT khác
- Thay đổi bảng: Áp dụng pattern cho bảng khác (wo_header, wp_header, etc.)
- Thêm điều kiện lọc: Thêm vào WHERE clause

**Ví dụ sử dụng**:
```sql
-- Lọc pickslip từ 7 ngày trước đến hôm nay
-- Copy pattern và thay '1 day' thành '7 days'

-- Lọc pickslip từ 30 ngày trước đến hôm nay
-- Copy pattern và thay '1 day' thành '30 days'

-- Lọc WO từ hôm qua đến hôm nay (áp dụng pattern cho wo_header)
-- Thay pickslip_header.created_date bằng wo_header.issue_date
```

## 🔍 Cách tìm kiếm

### Theo chức năng
- **Jobcard**: Xem section Jobcard Queries
- **Pickslip**: Xem section Pickslip Queries
- **Parse WO**: Tìm "parse WO" hoặc "extracted_wono"
- **Lọc thời gian**: Tìm "closing_date BETWEEN" hoặc "created_date BETWEEN" hoặc "interval"

### Theo pattern
- **Parse từ template**: Tìm "SPLIT_PART" và "template_number"
- **Join WO đã đóng**: Tìm "wo.state = 'C'"
- **Lọc ngày AMOS**: Tìm "1971-12-31" và "interval"
- **Lọc DATE_INT**: Tìm "BETWEEN" và "1971-12-31"

### Theo từ khóa
- **jobcard**: get_all_jobcards.sql
- **pickslip**: example_pickslip_yesterday_to_today.sql
- **WO đã đóng**: get_all_jobcards.sql
- **khoảng thời gian**: get_all_jobcards.sql, example_pickslip_yesterday_to_today.sql
- **lọc theo ngày**: example_pickslip_yesterday_to_today.sql
- **DATE_INT filter**: example_pickslip_yesterday_to_today.sql

## 📝 Lưu ý

- Tất cả query trong thư mục này đã được **xác nhận chính xác**
- Khi tạo query mới, **copy pattern** từ đây
- Giữ nguyên logic chính, chỉ thay đổi điều kiện lọc
- Luôn test query mới trước khi sử dụng

## 🔗 Liên kết

- [README.md](./README.md) - Tổng quan về reference queries
- [../INDEX.md](../INDEX.md) - Danh mục query theo chức năng
- [../QUERY_PATTERNS.md](../QUERY_PATTERNS.md) - Các pattern query
- [../KEYWORD_MAPPING.md](../KEYWORD_MAPPING.md) - Mapping từ khóa

