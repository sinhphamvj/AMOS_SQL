# 📚 Reference Queries - Các Query Mẫu Chính Xác

Thư mục này chứa các query đã được xác nhận là **chính xác và đúng với yêu cầu**. 
Sử dụng các query này làm **reference** khi tạo query mới tương tự.

## 📋 Danh sách Query Reference

### Jobcard Queries

#### `get_all_jobcards.sql`
**Mô tả**: Lấy jobcard có WO đã đóng trong khoảng thời gian cụ thể

**Tính năng**:
- Parse WO number từ tên jobcard (format: `JC-AXXX-YYYYYYYYY`)
- Join với WO đã đóng (state = 'C')
- Lọc theo khoảng thời gian (closing_date)
- Sử dụng pattern lọc ngày AMOS đúng chuẩn

**Pattern chính**:
```sql
-- Parse WO number từ template_number
CAST(NULLIF(SPLIT_PART(wt.template_number, '-', 3), '') AS INTEGER) AS extracted_wono

-- Join với WO đã đóng
INNER JOIN wo_header wo ON t.extracted_wono = wo.event_perfno_i
    AND wo.state = 'C'

-- Lọc theo khoảng thời gian (30 ngày)
AND wo.closing_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval '30 days')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date)
```

**Cách sử dụng**:
- Thay đổi số ngày: Sửa `'30 days'` thành số ngày mong muốn
- Thay đổi khoảng thời gian: Sửa công thức BETWEEN
- Thêm điều kiện lọc: Thêm vào WHERE clause của subquery `t` hoặc join với WO

### Pickslip Queries

#### `example_pickslip_yesterday_to_today.sql`
**Mô tả**: Ví dụ mẫu về cách lọc pickslip theo ngày trong AMOS

**Tính năng**:
- Lọc pickslip theo khoảng thời gian (created_date)
- Sử dụng pattern lọc ngày AMOS đúng chuẩn
- Join với pickslip_detail, od_detail, od_header, station_store
- Lọc theo station và status

**Pattern chính**:
```sql
-- Lọc từ hôm qua đến hôm nay (thay '1 day' thành số ngày mong muốn)
AND pickslip_header.created_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval '1 day')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date)

-- Lọc từ N ngày trước đến hôm nay
AND pickslip_header.created_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval 'N days')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date)
```

**Cách sử dụng**:
- Thay đổi số ngày: Sửa `'1 day'` thành số ngày mong muốn (ví dụ: `'7 days'`, `'30 days'`)
- Thay đổi khoảng thời gian: Sửa công thức BETWEEN
- Thêm điều kiện lọc: Thêm vào WHERE clause
- Thay đổi bảng: Áp dụng pattern cho bảng khác (thay `pickslip_header.created_date` bằng cột DATE_INT khác)

## 🎯 Cách sử dụng Reference Queries

1. **Tìm query tương tự**: Xem danh sách ở trên
2. **Copy pattern**: Lấy phần logic chính từ query reference
3. **Điều chỉnh**: Thay đổi điều kiện lọc, thêm/bớt cột
4. **Kiểm tra**: Đảm bảo tuân theo pattern đã được xác nhận

## 📝 Quy tắc

- Các query trong thư mục này đã được **xác nhận chính xác**
- Không sửa đổi query reference trừ khi có yêu cầu cụ thể
- Khi tạo query mới tương tự, **copy pattern** từ đây
- Luôn giữ nguyên logic chính, chỉ thay đổi điều kiện lọc

## 🔗 Liên kết

- [INDEX.md](../INDEX.md) - Danh mục query theo chức năng
- [QUERY_PATTERNS.md](../QUERY_PATTERNS.md) - Các pattern query thường dùng
- [TABLE_REFERENCE.md](../TABLE_REFERENCE.md) - Tham chiếu bảng database

