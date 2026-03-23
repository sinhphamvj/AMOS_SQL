# 🗄️ Database Table Reference

Tham chiếu các bảng chính trong hệ thống AMOS và cách sử dụng.

## 📋 Bảng chính

### Work Order & Jobcard

#### `wo_header`
**Mô tả**: Bảng chính chứa thông tin Work Order, Jobcard, Event Pending, Work Template

**Các loại record**:
- **Work Order**: `type IN ('M', 'P', 'C', 'S')` và `workorderno_display IS NOT NULL`
- **Jobcard**: `event_type = 'JC'`, `type = 'PD'`, `workorderno_display IS NULL`
- **Event Pending**: `type = 'PD'`, `workorderno_display IS NULL`
- **Work Template**: `type = 'T'`, `event_perfno_i < 0`

**Cột quan trọng**:
- `event_perfno_i` - ID duy nhất (PK)
- `ac_registr` - Mã máy bay
- `state` - Trạng thái: 'O' (Open), 'C' (Closed)
- `type` - Loại: 'M' (Maintenance), 'P' (Pirep), 'C' (Cabin), 'S' (Scheduled), 'PD' (Pending), 'T' (Template)
- `event_type` - Loại event: 'JC' (Jobcard), 'WO' (Work Order), etc.
- `issue_date` - Ngày issue (DATE_INT)
- `closing_date` - Ngày đóng (DATE_INT)
- `workorderno_display` - Số WO hiển thị (NULL cho Jobcard)
- `template_revisionno_i` - Link đến template

**Ví dụ query**:
```sql
-- Lấy WO đang mở
SELECT * FROM wo_header 
WHERE state = 'O' AND type IN ('M', 'P', 'C', 'S');

-- Lấy Jobcard
SELECT * FROM wo_header 
WHERE event_type = 'JC' AND type = 'PD' AND workorderno_display IS NULL;
```

#### `wo_header_more`
**Mô tả**: Thông tin bổ sung của WO

**Cột quan trọng**:
- `event_perfno_i` - FK đến wo_header
- `wo_class` - Class của WO: 'A', 'L', 'T'
- `mel_chapter` - Chapter MEL

#### `wo_text_description`
**Mô tả**: Mô tả của WO

**Cột quan trọng**:
- `descno_i` - ID description
- `text` - Nội dung mô tả

#### `wo_text_action`
**Mô tả**: Action của WO

**Cột quan trọng**:
- `actionno_i` - ID action
- `event_perfno_i` - FK đến wo_header
- `sign_performed` - Người thực hiện

### Work Template & Jobcard Template

#### `work_template`
**Mô tả**: Template của Work Order/Jobcard

**Cột quan trọng**:
- `wtno_i` - ID template (PK)
- `template_type` - Loại: 'J' (Jobcard), 'U' (Unlinked), 'C' (Customer Requirement)
- `template_number` - Số template (ví dụ: 'JC-AXXX-YYYYYYYYY')
- `template_title` - Tiêu đề template
- `preparation` - 'Y' nếu là preparation jobcard
- `status` - 0 (Active), 2 (Deactivated)

**Ví dụ query**:
```sql
-- Lấy Jobcard template
SELECT * FROM work_template 
WHERE template_type = 'J' AND status = 0;

-- Parse WO number từ tên jobcard
SELECT 
    template_number,
    SPLIT_PART(template_number, '-', 3)::INTEGER AS wo_event_perfno_i
FROM work_template
WHERE template_type = 'J' 
    AND template_number ~ '^JC-[^-]+-[0-9]+$';
```

#### `event_template`
**Mô tả**: Revision của template

**Cột quan trọng**:
- `template_revisionno_i` - ID revision (PK)
- `event_perfno_i` - FK đến wo_header (template)
- `wtno_i` - FK đến work_template
- `revision_number` - Số revision
- `revision_date` - Ngày revision

### Work Package

#### `wp_header`
**Mô tả**: Header của Work Package

**Cột quan trọng**:
- `wpno_i` - ID WP (PK)
- `ac_registr` - Mã máy bay
- `state` - Trạng thái WP
- `jobcards_collection_status` - Trạng thái collection jobcard

#### `wp_history`
**Mô tả**: Lịch sử WP

**Cột quan trọng**:
- `wpno_i` - FK đến wp_header
- `event_type` - Loại event
- `event_perfno_i` - FK đến wo_header

### Phụ tùng

#### `wo_part_on_off`
**Mô tả**: Part on/off trong WO

**Cột quan trọng**:
- `event_perfno_i` - FK đến wo_header
- `partno` - Part number on
- `serialno` - Serial number on
- `partno_off` - Part number off
- `serialno_off` - Serial number off
- `created_date` - Ngày tạo (DATE_INT)
- `status` - Trạng thái

#### `pickslip`
**Mô tả**: Pickslip

**Cột quan trọng**:
- `pickslipno_i` - ID pickslip (PK)
- `event_perfno_i` - FK đến wo_header

### Nhân sự

#### `sign`
**Mô tả**: Thông tin nhân viên

**Cột quan trọng**:
- `user_sign` - User sign (PK)
- `employee_no_i` - Số nhân viên
- `skill_shop` - Kỹ năng: 'B1', 'B2', 'A', 'MECH', etc.
- `homebase` - Base: 'SGN', 'HAN', 'DAD', etc.
- `department` - Phòng ban
- `status` - Trạng thái

#### `staff_pqs_qualification`
**Mô tả**: PQS qualification

**Cột quan trọng**:
- `employee_no_i` - FK đến sign
- `status` - Trạng thái

### Liên kết

#### `db_link`
**Mô tả**: Liên kết giữa các entity

**Cột quan trọng**:
- `source_pk` - Primary key của source (VARCHAR)
- `source_type` - Loại source: 'WO', 'WOA', etc.
- `destination_key` - Key của destination
- `ref_type` - Loại reference: 'WO', 'MEL', 'AMM', etc.
- `link_remarks` - Ghi chú link
- `description` - Mô tả

**Ví dụ query**:
```sql
-- Tìm WO liên kết với Jobcard
SELECT wo.* 
FROM wo_header jc
JOIN db_link ON jc.event_perfno_i::VARCHAR = db_link.source_pk
JOIN wo_header wo ON db_link.destination_key = wo.event_perfno_i::VARCHAR
WHERE jc.event_type = 'JC';
```

### Workstep

#### `workstep_link`
**Mô tả**: Link workstep

**Cột quan trọng**:
- `event_perfno_i` - FK đến wo_header
- `sequenceno` - Số thứ tự
- `descno_i` - FK đến wo_text_description

## 🔗 Quan hệ giữa các bảng

```
wo_header (Jobcard)
    ↓ (template_revisionno_i)
event_template
    ↓ (wtno_i)
work_template (template_number: 'JC-AXXX-YYYYYYYYY')
    ↓ (parse WO number từ template_number)
wo_header (WO với event_perfno_i = parsed number)

wo_header
    ↓ (event_perfno_i)
wo_header_more
wo_text_description
wo_text_action
wo_part_on_off

wo_header
    ↓ (db_link)
db_link
    ↓ (destination_key)
wo_header (linked WO)

wp_header
    ↓ (wpno_i)
wp_history
    ↓ (event_perfno_i)
wo_header
```

## 💡 Lưu ý quan trọng

### DATE_INT
- Ngày tháng trong AMOS được lưu dưới dạng INTEGER
- Mốc ngày: `1971-12-31`
- Số ngày từ mốc được lưu trong cột DATE_INT

**So sánh DATE_INT với ngày hiện tại:**
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

**Lưu ý**: Không dùng hàm `amos_to_date()` trong query vì AMOS không hỗ trợ

### Jobcard naming
- Format: `JC-AXXX-YYYYYYYYY`
- `AXXX`: Mã máy bay (ac_registr)
- `YYYYYYYYY`: event_perfno_i của WO liên kết
- Lưu trong: `work_template.template_number` với `template_type = 'J'`

### Work Order types
- `'M'`: Maintenance
- `'P'`: Pirep
- `'C'`: Cabin
- `'S'`: Scheduled
- `'PD'`: Pending (cho Jobcard, Event Pending)
- `'T'`: Template

### Event types
- `'JC'`: Jobcard
- `'WO'`: Work Order
- `'CT'`, `'CD'`, `'CC'`, `'CP'`: Customer Requirement

## 📚 Tài liệu tham khảo

- [Schema SQL](./vietjet_amos_schema.sql) - Schema đầy đủ (71,000+ dòng)

