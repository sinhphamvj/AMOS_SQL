---
name: amos
description: Hỗ trợ toàn diện cho hệ thống AMOS (Vietjet Air). Viết query SQL, tra cứu schema 2,141 bảng, 22 pattern query, ~160 query mẫu. Chuyển đổi HTML Table cho EditLive! (Ephox). Dùng khi làm việc với AMOS — SQL, schema, dashboard, hoặc soạn thảo HTML trong EditLive!.
---

# SKILL: AMOS SQL Query Assistant

Khi người dùng cần viết query SQL cho AMOS, tra cứu schema, hoặc tìm query mẫu, hãy sử dụng kiến thức cốt lõi bên dưới và đọc thêm các file tham chiếu khi cần.

**Thư mục gốc skill**: thư mục chứa file SKILL.md này (tất cả đường dẫn dưới đây là tương đối từ thư mục này).

---

## 1. AMOS Fundamentals

### DATE_INT — Hệ thống ngày AMOS
- Tất cả ngày lưu dưới dạng **INTEGER** (số ngày kể từ 1971-12-31)
- **Hiển thị**: `(DATE '1971-12-31' + date_column)::DATE`
- **Format**: `TO_CHAR(DATE '1971-12-31' + date_column, 'DD.MON.YYYY')`
- **So sánh (khuyến nghị)**: Chuyển ngày mục tiêu → integer, KHÔNG chuyển column → date
```sql
-- Lọc từ hôm qua đến hôm nay
WHERE created_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval '1 day')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date)
```
- **KHÔNG BAO GIỜ** dùng `amos_to_date()` — hàm này không tồn tại trong AMOS

### Entity Types trong wo_header
| Loại | Điều kiện |
|------|-----------|
| **Work Order** | `type IN ('M','P','C','S')` AND `workorderno_display IS NOT NULL` |
| **Jobcard** | `event_type = 'JC'` AND `type = 'PD'` AND `workorderno_display IS NULL` |
| **Event Pending** | `type = 'PD'` AND `workorderno_display IS NULL` |
| **Template** | `type = 'T'` AND `event_perfno_i < 0` |

### WO Types
- `M` = Maintenance, `P` = Pirep, `C` = Cabin, `S` = Scheduled

### Status Conventions
- `wo_header.state`: `'O'` = Open, `'C'` = Closed
- `status`: `0` = Active, `9` = Deleted
- **CẢNH BÁO**: `wp_header` KHÔNG có cột `state` — dùng `wp_header.status <> 9` thay thế

### Station Codes (Vietjet)
SGN, HAN, DAD, CXR, HPH, VCA, PQC, VII, VTE

### Naming Conventions
- Hậu tố `_i` = Primary Key (event_perfno_i, wpno_i, descno_i)
- Jobcard name format: `JC-AXXX-YYYYYYYYY` (AXXX = ac_registr, YYY = WO event_perfno_i)
- Lưu trong `work_template.template_number` với `template_type = 'J'`

### SQL-Central AMOS Restrictions
- **KHÔNG được** có comment (`--` hoặc `/* */`) trước câu lệnh `SELECT` đầu tiên
- Lỗi: `A batch has to begin with a select/update/insert/delete-command`

---

## 2. Top 10 Tables

| # | Bảng | PK | Mô tả |
|---|------|----|-------|
| 1 | `wo_header` | event_perfno_i | WO/Jobcard header — bảng quan trọng nhất (140 lần sử dụng) |
| 2 | `sign` | sign | Thông tin nhân viên (109) |
| 3 | `wp_header` | wpno_i | Work Package header — 114 columns (93) |
| 4 | `workstep_link` | event_perfno_i + sequenceno | Link WO → description (73) |
| 5 | `wo_text_description` | descno_i | Mô tả WO (65) |
| 6 | `address` | addressno_i | Address/Vendor master (61) |
| 7 | `wp_assignment` | wpno_i + event_perfno_i | WP assignment (51) |
| 8 | `wo_header_more` | event_perfno_i | Thông tin bổ sung WO (44) |
| 9 | `event_template` | event_perfno_i | Template revision (41) |
| 10 | `work_template` | template_revisionno_i | WO/JC template (28) |

---

## 3. Core Join Patterns

### WO + Description (lấy description mới nhất)
```sql
LEFT JOIN workstep_link wl ON wo.event_perfno_i = wl.event_perfno_i
    AND wl.sequenceno = (
        SELECT MAX(sequenceno)
        FROM workstep_link wl2
        WHERE wl2.event_perfno_i = wo.event_perfno_i
    )
LEFT JOIN wo_text_description wo_desc ON wl.descno_i = wo_desc.descno_i
```

### WO + Header More
```sql
LEFT JOIN wo_header_more wm ON wo.event_perfno_i = wm.event_perfno_i
```

### Jobcard → Parse WO number
```sql
-- Jobcard name: JC-AXXX-YYYYYYYYY → extract WO event_perfno_i
CAST(NULLIF(SPLIT_PART(wt.template_number, '-', 3), '') AS INTEGER) AS wo_event_perfno_i
-- Filter: wt.template_type = 'J' AND wt.template_number ~ '^JC-[^-]+-[0-9]+$'
```

### WP + Assignment
```sql
LEFT JOIN wp_assignment wpa ON wp.wpno_i = wpa.wpno_i
LEFT JOIN wo_header wo ON wpa.event_perfno_i = wo.event_perfno_i
```

### Resource Online
```sql
-- sign + sp_user_availability + sp_shift
-- Xem chi tiết: resource/counter_resource_online.sql
```

---

## 4. Lỗi Thường Gặp

| Lỗi | Nguyên nhân | Sửa |
|-----|-------------|-----|
| `column wp_header.state does not exist` | wp_header KHÔNG có cột state | Dùng `wp_header.status <> 9` |
| `A batch has to begin with a select/update/insert/delete-command` | Comment trước SELECT | Xóa tất cả comment đầu query |
| `Unterminated string literal` trong Report Designer | Report Designer đổi `'` → backtick | Find & Replace `` ` `` → `'` |
| `OutOfMemoryError: Java heap space` | Query không có bộ lọc ngày | Luôn thêm WHERE date filter |
| Header Daily Check sai | Dùng `LIKE 'PERFORM CHECK:%'` | Header chỉ là `'DAILY CHECK'` (text chi tiết nằm ở cột `text`) |

---

## 5. Tham Chiếu File (Router)

Khi cần thông tin chi tiết, hãy **đọc file tương ứng** từ thư mục skill:

| Cần tìm | Đọc file | Ghi chú |
|----------|----------|---------|
| Chi tiết columns của bảng cụ thể | `COLUMN_INDEX.md` | Columns thường dùng + mô tả |
| Query có sẵn theo keyword | `KEYWORD_MAPPING.md` | Map từ khóa → file SQL |
| Query có sẵn theo chức năng | `INDEX.md` | ~160 queries phân loại theo domain |
| Chi tiết 22 query patterns | `QUERY_PATTERNS.md` | Code mẫu cho từng pattern |
| Thống kê table/column usage | `QUERY_TABLE_COLUMN_USAGE.md` | Phân tích từ 131 queries |
| Schema bảng cụ thể | `vietjet_amos_schema.sql` | Dùng Grep tìm tên bảng (71K dòng) |
| Index tất cả 2,141 bảng | `SCHEMA_INDEX.md` | Tra cứu bảng theo prefix/chức năng |
| Tham chiếu bảng chính | `TABLE_REFERENCE.md` | Các bảng chính + relationships |
| Insights & kiến thức tích lũy | `MEMORY_BANK.md` | Top tables, patterns, errors |
| Query mẫu đã xác nhận chính xác | `reference_queries/` | Jobcard, Pickslip (verified) |

**Lưu ý**: File `vietjet_amos_schema.sql` rất lớn (71K dòng). Dùng **Grep** tìm tên bảng cụ thể, KHÔNG đọc toàn bộ file.

---

## 6. Quy Trình Viết Query

1. **Xác định keywords** từ yêu cầu người dùng
2. **Kiểm tra KEYWORD_MAPPING.md** — có pattern/query nào khớp không?
3. **Kiểm tra INDEX.md** — có query có sẵn nào tương tự không?
4. **Nếu có query sẵn** → đọc file SQL đó, adapt theo yêu cầu mới
5. **Nếu cần query mới** → dùng patterns từ QUERY_PATTERNS.md làm khung
6. **Áp dụng quy tắc**:
   - DATE_INT: dùng công thức chuẩn (Section 1)
   - Status filter: state O/C cho wo_header, status <> 9 cho wp_header
   - Station filter khi cần
   - Luôn thêm date filter để tránh OutOfMemoryError
7. **Validate trước khi xuất**:
   - Không có comment trước SELECT
   - Không dùng `amos_to_date()`
   - Không dùng `wp_header.state`
   - Không dùng `border-collapse` nếu output là HTML cho EditLive!

---

## 7. Business Domains

Các domain chính của queries trong repository:

| Domain | Thư mục | Số files |
|--------|---------|----------|
| Daily Operations & Reporting | `daily report/` | 30 |
| Work Package Management | `wp/` | 32 |
| Resource & Manpower | `resource/` | 32 |
| Parts & Inventory | `part_pooling/`, `part_hangar/` | 20 |
| Dashboard & Analytics | `dashboard/` | 9 |
| ADD Sheet / MEL / OPS | `ADD_SHEET/` | 9 |
| Daily WP Database | `DLYWP_DB/` | 9 |
| Staff Management | `staff/` | 7 |
| E-Expansion Sheet (CAAV/FSSD) | `E-expsheet/` | 4 |
| Maintenance Control | `maint_control/` | 2 |

---

## 8. Chuyển Đổi HTML Table cho EditLive!

AMOS sử dụng trình soạn thảo nhúng **EditLive! Enterprise Edition** (Ephox, Java Applet cũ). Engine này **KHÔNG HỖ TRỢ**: `border-collapse`, `border-spacing`, CSS `border` định hướng (border-top, border-left, v.v.)

Nếu dùng CSS thông thường: viền bị nhân đôi, mất nét dọc, hở góc chữ T.

### Giải pháp: "Background-color as Border"
Dùng **nền đen của `<table>`** làm màu viền, `cellspacing="1"` tạo khe hở 1px, mỗi `<td>` có nền trắng lấp lên → chừa lại khe 1px = viền đơn liền mạch.

### 4 Quy luật chuyển đổi (BẮT BUỘC 100%)

**Quy luật 1 — `<table>`**
- `border="0"` (KHÔNG dùng `border="1"`)
- `cellspacing="1"` (tạo khe viền 1px)
- `cellpadding="0"` (padding đặt ở td)
- `bgcolor="#000000"` + `style="background-color: #000000; width: 100%;"` (khai báo kép)
- XÓA toàn bộ: `border-collapse`, `border-spacing`, CSS `border` trên table

**Quy luật 2 — `<tr>`**
- KHÔNG gán `bgcolor`, `background`, hay `border` vào `<tr>`

**Quy luật 3 — `<td>` và `<th>`**
- BẮT BUỘC khai báo kép: `bgcolor="#ffffff"` VÀ `style="background-color: #ffffff; padding: 5px;"`
- Nếu ô cần nền màu khác: thay `#ffffff` bằng màu tương ứng
- XÓA toàn bộ CSS `border` khỏi `<td>`
- Giữ lại: `valign`, `align`

**Quy luật 4 — Văn bản & Căn lề**
- Dùng thuộc tính nguyên thủy: `valign="top"`, `align="center"` (không dùng CSS)
- Nhiều `<p>` trong ô: thêm `style="margin: 0;"` vào mỗi `<p>`
- Chuyển width **px → %** (ví dụ: 200px trong tổng 500px → 40%)

### Ví dụ

**Đầu vào (Bad):**
```html
<table border="1" style="border-collapse: collapse;">
  <tr>
    <td style="border: 1px solid black; width: 200px;">Text 1</td>
    <td style="border: 1px solid black; width: 300px;">Text 2</td>
  </tr>
</table>
```

**Đầu ra (Good — AMOS compatible):**
```html
<table border="0" cellspacing="1" cellpadding="0" bgcolor="#000000" style="background-color: #000000; width: 100%;">
  <tr>
    <td bgcolor="#ffffff" style="background-color: #ffffff; padding: 5px;" valign="top" align="left" width="40%">Text 1</td>
    <td bgcolor="#ffffff" style="background-color: #ffffff; padding: 5px;" valign="top" align="left" width="60%">Text 2</td>
  </tr>
</table>
```

### Lưu ý đặc biệt
- **Merged cells** (`colspan`, `rowspan`): giữ nguyên, chỉ xử lý style
- **Nested tables**: xử lý từng table theo cùng quy luật
- **Header cells** (`<th>`): đổi thành `<td>` với `bgcolor="#e0e0e0"` (nền xám nhạt) + `<strong>` cho text
- **Màu viền tùy chỉnh**: đổi `#000000` trên `<table>` thành màu mong muốn
