# 📊 AMOS Database Column Index

Index chi tiết các column quan trọng trong các bảng chính của AMOS để tra cứu nhanh khi tạo query.

**Nguồn dữ liệu**: 
- Phân tích từ **131 file SQL** trong các thư mục con (xem [QUERY_TABLE_COLUMN_USAGE.md](./QUERY_TABLE_COLUMN_USAGE.md))
- Schema đầy đủ từ [vietjet_amos_schema.sql](./vietjet_amos_schema.sql)

**Lưu ý**: File này ưu tiên index các bảng và column **thường dùng nhất** từ queries thực tế.

## 🔍 Tra cứu nhanh theo chức năng

### Tìm column theo từ khóa
- **Ngày tháng**: `*_date`, `*_time` (DATE_INT)
- **Trạng thái**: `state`, `status`
- **Mã máy bay**: `ac_registr`
- **Mã part**: `partno`, `comp_partno`
- **Serial number**: `serialno`, `comp_serialno`
- **User/Sign**: `*_sign`, `created_by`, `mutator`
- **Station**: `*_station`, `station_from`, `station_to`
- **WO number**: `workorderno_display`, `event_perfno_i`

---

## 📋 Bảng: `wo_header` ⭐⭐ (140 lần sử dụng - Bảng được dùng nhiều nhất)

**Mô tả**: Bảng chính chứa Work Order, Jobcard, Event Pending, Template

### Column quan trọng (từ queries thực tế - 19 columns thường dùng)

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `event_perfno_i` | INTEGER | Unique identifier (PK). Negative cho templates | > 0: WO/Jobcard, < 0: Template |
| `ac_registr` | VARCHAR(6) | Mã máy bay | 'VN-A123', etc. |
| `state` | VARCHAR(2) | Trạng thái WO | 'O' (Open), 'C' (Closed) |
| `type` | VARCHAR(2) | Loại WO | 'M' (Maintenance), 'P' (Pirep), 'C' (Cabin), 'S' (Scheduled), 'PD' (Pending), 'T' (Template), 'NT' (Non-Technical) |
| `event_type` | VARCHAR(2) | Loại event | 'JC' (Jobcard), 'WO', 'CT', 'CD', 'CC', 'CP', 'SH' (Shopcard), etc. |
| `issue_date` | INTEGER | Ngày issue (DATE_INT) | Số ngày từ 1971-12-31 |
| `issue_station` | VARCHAR(4) | Station issue | 'SGN', 'HAN', 'DAD', etc. |
| `closing_date` | INTEGER | Ngày đóng (DATE_INT) | Số ngày từ 1971-12-31 |
| `workorderno_display` | INTEGER | Số WO hiển thị | NULL cho Jobcard |
| `template_revisionno_i` | INTEGER | Link đến template | FK đến event_template |
| `ata_chapter` | VARCHAR(12) | ATA chapter | '21-XX-XX', etc. |
| `mel_code` | VARCHAR(2) | MEL code | 'A', 'B', 'C', 'D', 'L' (CDL) |
| `hil` | VARCHAR(1) | Hold Item List | 'Y' hoặc NULL |
| `mech_sign` | VARCHAR(8) | Mechanic sign (closing) | User sign |
| `release_station` | VARCHAR(4) | Release station (closing) | Station code |
| `release_time` | VARCHAR(4) | Release time (closing) | Time format (1445 = 14:45) |
| `projectno` | VARCHAR(14) | Project number | Project code |
| `prio` | VARCHAR(4) | Priority | Priority code |
| `psn` | INTEGER | Component PSN (Unique identifier cho Rotable) | PSN number |

### Cách xác định loại record

**Work Order**:
```sql
WHERE type IN ('M', 'P', 'C', 'S') 
  AND event_perfno_i > 0 
  AND workorderno_display IS NOT NULL
```

**Jobcard**:
```sql
WHERE event_type = 'JC' 
  AND type = 'PD' 
  AND event_perfno_i > 0 
  AND workorderno_display IS NULL
```

**Event Pending**:
```sql
WHERE type = 'PD' 
  AND event_perfno_i > 0 
  AND workorderno_display IS NULL
```

**Work Template**:
```sql
WHERE type = 'T' 
  AND event_perfno_i < 0
```

---

## 📋 Bảng: `work_template` ⭐ (28 lần sử dụng)

**Mô tả**: Template của Work Order/Jobcard

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `wtno_i` | INTEGER | ID template (PK) | Integer |
| `template_type` | VARCHAR | Loại template | 'J' (Jobcard), 'U' (Unlinked), 'C' (Customer Requirement) |
| `template_number` | VARCHAR | Số template | 'JC-AXXX-YYYYYYYYY' format cho Jobcard |
| `template_title` | VARCHAR | Tiêu đề template | Title text |
| `preparation` | VARCHAR(1) | Preparation jobcard | 'Y' hoặc NULL |
| `status` | INTEGER | Trạng thái | 0 (Active), 2 (Deactivated) |

---

## 📋 Bảng: `pickslip_header` ⭐

**Mô tả**: Header của pickslip

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `pickslipno` | VARCHAR(10) | Số pickslip | Pickslip number |
| `pickslipno_i` | INTEGER | ID pickslip (nếu có) | Integer |
| `station_from` | VARCHAR(4) | Station nguồn | 'SGN', 'HAN', 'DAD', etc. |
| `station_to` | VARCHAR(4) | Station đích | Station code |
| `store_from` | VARCHAR(8) | Store nguồn | Store code |
| `store_to` | VARCHAR(8) | Store đích | Store code |
| `mech_sign` | VARCHAR(8) | Mechanic sign | User sign |
| `receiver` | VARCHAR(8) | Người nhận | User sign |
| `booking_sign` | VARCHAR(8) | Booking sign | User sign |
| `confirm_sign` | VARCHAR(8) | Confirm sign | User sign |
| `issue_date` | INTEGER | Ngày issue (DATE_INT) | Số ngày từ 1971-12-31 |
| `issue_time` | INTEGER | Thời gian issue | Milliseconds |
| `created_date` | INTEGER | Ngày tạo (DATE_INT) | Số ngày từ 1971-12-31 |
| `pickslip_date` | INTEGER | Ngày pickslip (DATE_INT) | Số ngày từ 1971-12-31 |
| `planned_date` | INTEGER | Ngày planned (DATE_INT) | Số ngày từ 1971-12-31 |
| `state` | VARCHAR(2) | Trạng thái pickslip | State code |
| `status` | INTEGER | Status | 0, 1, 2, 4 (thường dùng) |
| `prio` | VARCHAR(4) | Priority | Priority code |
| `projectno` | VARCHAR(14) | Project number | Project code |

---

## 📋 Bảng: `pickslip_detail` ⭐

**Mô tả**: Chi tiết pickslip

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `pickslipno` | VARCHAR(10) | Số pickslip (FK) | Pickslip number |
| `recno` | INTEGER | Record number | Integer |
| `partno` | VARCHAR(32) | Part number | Part number |
| `serialno` | VARCHAR(20) | Serial number | Serial number |
| `oddetailno_i` | INTEGER | FK đến od_detail | Integer |
| `event_perfno_i` | INTEGER | FK đến wo_header | Integer |
| `qty_req` | VARCHAR(255) | Quantity required | Quantity |
| `qty_sys` | VARCHAR(255) | Quantity system | Quantity |
| `qty_booked` | VARCHAR(255) | Quantity booked | Quantity |
| `date_booked` | INTEGER | Ngày booked (DATE_INT) | Số ngày từ 1971-12-31 |
| `expected_date` | INTEGER | Expected date (DATE_INT) | Số ngày từ 1971-12-31 |
| `status` | INTEGER | Status | Integer |

---

## 📋 Bảng: `od_header` ⭐

**Mô tả**: Header của order

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `orderno_i` | INTEGER | ID order (PK) | Integer |
| `order_type` | VARCHAR(2) | Loại order | 'T' (Transfer), etc. |
| `goods_destination` | INTEGER | Goods destination (FK) | FK đến station_store.address_i |
| `ac_registr` | VARCHAR(6) | Mã máy bay | Aircraft registration |
| `state` | VARCHAR(2) | Trạng thái order | State code |
| `status` | INTEGER | Status | Integer |
| `vendor` | VARCHAR(12) | Vendor (FK) | FK đến address |
| `entry_date` | INTEGER | Ngày entry (DATE_INT) | Số ngày từ 1971-12-31 |
| `entry_sign` | VARCHAR(8) | User entry | User sign |

---

## 📋 Bảng: `od_detail` ⭐

**Mô tả**: Chi tiết order

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `detailno_i` | INTEGER | ID detail (PK) | Integer |
| `orderno_i` | INTEGER | FK đến od_header | Integer |
| `posno` | INTEGER | Position number | Integer |
| `order_type` | VARCHAR(2) | Loại order | 'T', etc. |
| `partno` | VARCHAR(32) | Part number | Part number |
| `serialno` | VARCHAR(20) | Serial number | Serial number |
| `qty` | VARCHAR(255) | Quantity | Quantity |
| `backorder` | VARCHAR(255) | Backorder quantity | Quantity |
| `target_date` | INTEGER | Target date (DATE_INT) | Số ngày từ 1971-12-31 |
| `confirmed_date` | INTEGER | Confirmed date (DATE_INT) | Số ngày từ 1971-12-31 |
| `del_date` | INTEGER | Delivery date (DATE_INT) | Số ngày từ 1971-12-31 |
| `pickslipno` | VARCHAR(10) | Pickslip number | Pickslip number |
| `pickslipseqno_i` | INTEGER | Pickslip sequence | Integer |
| `condition` | VARCHAR(2) | Condition | Condition code |
| `status` | INTEGER | Status | Integer |

---

## 📋 Bảng: `wo_text_description` ⭐⭐ (65 lần sử dụng)

**Mô tả**: Mô tả của WO

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `descno_i` | INTEGER | ID description (PK) | Integer |
| `text` | TEXT | Nội dung mô tả | Text content |

---

## 📋 Bảng: `workstep_link` ⭐⭐ (73 lần sử dụng)

**Mô tả**: Link workstep

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `event_perfno_i` | INTEGER | FK đến wo_header | Integer |
| `sequenceno` | INTEGER | Số thứ tự | Integer (MAX = mới nhất) |
| `descno_i` | INTEGER | FK đến wo_text_description | Integer |

---

## 📋 Bảng: `sign` ⭐⭐ (109 lần sử dụng)

**Mô tả**: Thông tin nhân viên

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `user_sign` | VARCHAR(8) | User sign (PK) | User sign |
| `employee_no_i` | INTEGER | Số nhân viên | Employee number |
| `skill_shop` | VARCHAR | Kỹ năng | 'B1', 'B2', 'A', 'MECH', etc. |
| `homebase` | VARCHAR(4) | Base | 'SGN', 'HAN', 'DAD', etc. |
| `department` | VARCHAR | Phòng ban | Department code |
| `status` | INTEGER | Trạng thái | Integer |

---

## 📋 Bảng: `wp_header` ⭐⭐ (93 lần sử dụng, 114 columns)

**Mô tả**: Header của Work Package

> ⚠️ **Lưu ý quan trọng**: `wp_header` KHÔNG có cột `state`.
> - Khác với `wo_header` dùng `state = 'O'/'C'`
> - `wp_header` dùng `status` (INTEGER): `status <> 9` để loại WP đã xoá

### Column quan trọng (từ queries thực tế)

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `wpno_i` | INTEGER | ID WP (PK) | Integer |
| `wpno` | VARCHAR | Số WP | WP number |
| `ac_registr` | VARCHAR(6) | Mã máy bay | Aircraft registration |
| `ac_typ` | VARCHAR | Aircraft type | Aircraft type |
| `station` | VARCHAR(4) | Station | 'SGN', 'HAN', 'DAD', etc. |
| `state` | VARCHAR(2) | Trạng thái WP | State code |
| `status` | INTEGER | Status | Integer |
| `jobcards_collection_status` | VARCHAR | Trạng thái collection jobcard | Status code |
| `start_date` | INTEGER | Ngày bắt đầu (DATE_INT) | Số ngày từ 1971-12-31 |
| `start_time` | INTEGER | Thời gian bắt đầu | Milliseconds |
| `end_date` | INTEGER | Ngày kết thúc (DATE_INT) | Số ngày từ 1971-12-31 |
| `end_time` | INTEGER | Thời gian kết thúc | Milliseconds |
| `act_start_date` | INTEGER | Ngày bắt đầu thực tế (DATE_INT) | Số ngày từ 1971-12-31 |
| `act_start_time` | INTEGER | Thời gian bắt đầu thực tế | Milliseconds |
| `act_end_date` | INTEGER | Ngày kết thúc thực tế (DATE_INT) | Số ngày từ 1971-12-31 |
| `act_end_time` | INTEGER | Thời gian kết thúc thực tế | Milliseconds |
| `est_start_date` | INTEGER | Ngày bắt đầu ước tính (DATE_INT) | Số ngày từ 1971-12-31 |
| `est_start_time` | INTEGER | Thời gian bắt đầu ước tính | Milliseconds |
| `est_end_date` | INTEGER | Ngày kết thúc ước tính (DATE_INT) | Số ngày từ 1971-12-31 |
| `est_end_time` | INTEGER | Thời gian kết thúc ước tính | Milliseconds |
| `est_groundtime` | INTEGER | Estimated groundtime | Minutes |
| `target_start_date` | INTEGER | Target start date (DATE_INT) | Số ngày từ 1971-12-31 |
| `target_start_time` | INTEGER | Target start time | Milliseconds |
| `target_end_date` | INTEGER | Target end date (DATE_INT) | Số ngày từ 1971-12-31 |
| `target_end_time` | INTEGER | Target end time | Milliseconds |
| `inbound_scheduled_date` | INTEGER | Inbound scheduled date (DATE_INT) | Số ngày từ 1971-12-31 |
| `inbound_scheduled_time` | INTEGER | Inbound scheduled time | Milliseconds |
| `closing_date` | INTEGER | Ngày đóng (DATE_INT) | Số ngày từ 1971-12-31 |
| `wp_type` | VARCHAR | Loại WP | WP type code |
| `wp_status` | VARCHAR | Trạng thái WP | WP status code |
| `remarks` | TEXT | Ghi chú | Text |
| `projectno` | VARCHAR(14) | Project number | Project code |
| `created_date` | INTEGER | Ngày tạo (DATE_INT) | Số ngày từ 1971-12-31 |
| `created_by` | VARCHAR(8) | User tạo | User sign |
| `mutation` | INTEGER | Ngày mutation (DATE_INT) | Số ngày từ 1971-12-31 |
| `mutator` | VARCHAR(8) | User thay đổi | User sign |

---

## 📋 Bảng: `wp_assignment` ⭐ (51 lần sử dụng)

**Mô tả**: Assignment của Work Package

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `wpno_i` | INTEGER | FK đến wp_header | Integer |
| `event_perfno_i` | INTEGER | FK đến wo_header | Integer |
| `sequence_on_assignment` | INTEGER | Sequence | Integer |
| `status` | INTEGER | Status | Integer |

---

## 📋 Bảng: `address` ⭐ (61 lần sử dụng, 33 columns)

**Mô tả**: Address/Vendor master

### Column quan trọng

| Column | Type | Mô tả | Giá trị có thể |
|--------|------|-------|----------------|
| `address_i` | INTEGER | ID address (PK) | Integer |
| `vendor` | VARCHAR(12) | Vendor code | Vendor code |
| `type_i` | INTEGER | Type | Type code |
| `parent` | INTEGER | Parent address | FK đến address |
| `status` | INTEGER | Status | Integer |
| `remarks` | TEXT | Ghi chú | Text |
| `bill_text` | TEXT | Bill text | Text |
| `created_date` | INTEGER | Ngày tạo (DATE_INT) | Số ngày từ 1971-12-31 |
| `mutation` | INTEGER | Ngày mutation (DATE_INT) | Số ngày từ 1971-12-31 |
| `mutation_time` | TIME | Thời gian mutation | Time |
| `mutator` | VARCHAR(8) | User thay đổi | User sign |

---

## 💡 Lưu ý quan trọng

### DATE_INT
- Tất cả cột ngày tháng là INTEGER (DATE_INT)
- Mốc: `1971-12-31`
- Số ngày từ mốc được lưu trong cột

**So sánh DATE_INT**:
```sql
WHERE created_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval '1 day')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date)
```

**Hiển thị DATE_INT**:
```sql
SELECT (DATE '1971-12-31' + date_column)::DATE AS display_date
```

### Giá trị NULL
- `workorderno_display IS NULL` → Jobcard
- `workorderno_display IS NOT NULL` → Work Order

### State values
- `state = 'O'` → Open
- `state = 'C'` → Closed

### Type values
- `type = 'M'` → Maintenance
- `type = 'P'` → Pirep
- `type = 'C'` → Cabin
- `type = 'S'` → Scheduled
- `type = 'PD'` → Pending
- `type = 'T'` → Template

---

## 📊 Thống kê từ Queries Thực Tế

**Phân tích từ 131 file SQL trong các thư mục con:**

### Top 10 Bảng Thường Dùng Nhất
1. `wo_header` - 140 lần
2. `sign` - 109 lần
3. `wp_header` - 93 lần
4. `workstep_link` - 73 lần
5. `wo_text_description` - 65 lần
6. `address` - 61 lần
7. `wp_assignment` - 51 lần
8. `wo_header_more` - 44 lần
9. `event_template` - 41 lần
10. `work_template` - 28 lần

Xem chi tiết: [QUERY_TABLE_COLUMN_USAGE.md](./QUERY_TABLE_COLUMN_USAGE.md)

---

## 🔗 Liên kết

- [QUERY_TABLE_COLUMN_USAGE.md](./QUERY_TABLE_COLUMN_USAGE.md) ⭐ - Phân tích table/column từ queries thực tế
- [SCHEMA_INDEX.md](./SCHEMA_INDEX.md) - Index tất cả bảng
- [TABLE_REFERENCE.md](./TABLE_REFERENCE.md) - Tham chiếu bảng chính
- [vietjet_amos_schema.sql](./vietjet_amos_schema.sql) - Schema đầy đủ với COMMENT ON COLUMN

---

**⭐ = Bảng quan trọng - Có chi tiết column trong file này**  
**⭐⭐ = Bảng rất quan trọng - Được sử dụng nhiều nhất trong queries thực tế**

