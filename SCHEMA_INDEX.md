# 📚 AMOS Database Schema Index

**Tổng số bảng**: **2,141 bảng**

File này cung cấp index để tra cứu nhanh các bảng trong database AMOS. 
- Xem [COLUMN_INDEX.md](./COLUMN_INDEX.md) ⭐⭐ để tra cứu chi tiết column của các bảng quan trọng
- Xem [TABLE_REFERENCE.md](./TABLE_REFERENCE.md) để biết các bảng chính và cách sử dụng

## 🔍 Tra cứu nhanh

### Tìm bảng theo từ khóa
- **Work Order**: `wo_header`, `wo_header_more`, `wo_text_description`, `wo_text_action`
- **Jobcard**: `wo_header` (với `event_type='JC'`), `work_template` (với `template_type='J'`)
- **Pickslip**: `pickslip_header`, `pickslip_detail`
- **Order**: `od_header`, `od_detail`
- **Work Package**: `wp_header`, `wp_history`
- **Parts**: `part_*`, `rotable_*`
- **Staff**: `sign`, `staff_*`
- **Aircraft**: `ac_*`, `aircraft`
- **Template**: `work_template`, `event_template`

### Tìm bảng theo prefix
- `wo_*` - Work Order related (100+ bảng)
- `wp_*` - Work Package related
- `ac_*` - Aircraft related (35 bảng)
- `part_*` - Parts related
- `od_*` - Order related (50+ bảng)
- `pickslip*` - Pickslip related
- `staff_*` - Staff related
- `adr_*` - Address/Vendor related (29 bảng)
- `msc_*` - Maintenance Program related (68 bảng)
- `a2a_*` - AMOS to AMOS (4 bảng)
- `aero_*` - Aero Repair (13 bảng)

## 📋 Danh sách bảng theo chức năng

### 🔧 Work Order & Jobcard (100+ bảng)

#### Bảng chính
- **`wo_header`** ⭐ - Bảng chính chứa WO, Jobcard, Event Pending, Template
  - Xem [TABLE_REFERENCE.md](./TABLE_REFERENCE.md#wo_header) để biết chi tiết
- **`wo_header_more`** - Thông tin bổ sung của WO
- **`wo_text_description`** - Mô tả của WO
- **`wo_text_action`** - Action của WO
- **`work_template`** ⭐ - Template của Jobcard/WO
  - Xem [TABLE_REFERENCE.md](./TABLE_REFERENCE.md#work_template) để biết chi tiết
- **`event_template`** - Revision của template

#### Bảng liên quan
- `wo_*` - Tất cả bảng bắt đầu bằng `wo_` (100+ bảng)
- `workstep_link` - Link workstep
- `wo_part_on_off` - Part on/off trong WO
- `wo_feedback_request` - Feedback request
- `wo_header_4`, `wo_header_5`, etc. - Các bảng mở rộng của wo_header

### 📦 Pickslip & Order (60+ bảng)

#### Pickslip
- **`pickslip_header`** ⭐ - Header của pickslip
  - Key columns: `pickslipno`, `pickslipno_i`, `station_from`, `mech_sign`, `receiver`, `issue_date`, `created_date`, `status`
- **`pickslip_detail`** ⭐ - Chi tiết pickslip
  - Key columns: `pickslipno`, `oddetailno_i` (FK đến od_detail)

#### Order
- **`od_header`** ⭐ - Header của order
  - Key columns: `orderno_i` (PK), `order_type`, `goods_destination`, `status`
- **`od_detail`** ⭐ - Chi tiết order
  - Key columns: `detailno_i` (PK), `orderno_i` (FK), `partno`, `serialno`
- `od_*` - Tất cả bảng order (50+ bảng)

### 📋 Work Package (10+ bảng)

- **`wp_header`** ⭐ - Header của Work Package
  - Key columns: `wpno_i` (PK), `ac_registr`, `state`, `jobcards_collection_status`
- **`wp_history`** - Lịch sử WP
  - Key columns: `wpno_i` (FK), `event_type`, `event_perfno_i`
- `wp_*` - Tất cả bảng WP

### ✈️ Aircraft (35 bảng)

- **`ac_typ`** - Aircraft type
- **`ac_utilization`** - Aircraft utilization
- **`ac_daily_average`** - Daily average
- **`ac_future_flights`** - Future flights
- **`ac_frozen_flights`** - Frozen flights
- `ac_*` - Tất cả bảng aircraft

### 🔩 Parts & Inventory (100+ bảng)

- **`part_*`** - Parts related tables
- **`rotable_*`** - Rotable parts
- **`stock_*`** - Stock management
- **`inventory_*`** - Inventory management

### 👥 Staff & Resource (50+ bảng)

- **`sign`** ⭐ - Thông tin nhân viên
  - Key columns: `user_sign` (PK), `employee_no_i`, `skill_shop`, `homebase`, `department`
- **`staff_pqs_qualification`** - PQS qualification
- **`staff_*`** - Tất cả bảng staff
- **`resource_*`** - Resource management

### 🏢 Address & Vendor (29 bảng)

- **`address`** - Address master
- **`adr_*`** - Address related (29 bảng)

### 📊 Maintenance Program (68 bảng)

- **`msc_*`** - Maintenance Program related (68 bảng)
- **`mp_*`** - Maintenance Program related

### 🔗 Link & Reference (7 bảng)

- **`db_link`** ⭐ - Liên kết giữa các entity
  - Key columns: `source_pk`, `source_type`, `destination_key`, `ref_type`
- `db_link_*` - Link related tables

### 🔄 A2A (AMOS to AMOS) (4 bảng)

- **`a2a_acknowledgement`** - A2A acknowledgement
- **`a2a_order`** - A2A order
- **`a2a_quotation_*`** - A2A quotation

### 🔧 Aero Repair (13 bảng)

- **`aero_repair`** - Aero repair header
- **`aero_repair_quote`** - Quote
- **`aero_repair_receipt`** - Receipt
- **`aero_repair_ship`** - Shipment
- `aero_*` - Tất cả bảng aero repair

### 📈 Forecast (11 bảng)

- **`forecast`** - Forecast master
- **`forecast_*`** - Forecast related
- **`mevt_forecast`** - Maintenance event forecast
- **`reo_forecast`** - Rotable event forecast

### 📦 Other (1,589 bảng)

Các bảng khác không thuộc các nhóm trên. 
Sử dụng search trong schema file để tìm bảng cụ thể.

## 🔍 Index theo Keywords

### Work Order
| Keyword | Bảng |
|---------|------|
| work order, WO | `wo_header` |
| jobcard, JC | `wo_header` (với `event_type='JC'`), `work_template` |
| template | `work_template`, `event_template` |
| description | `wo_text_description` |
| action | `wo_text_action` |
| workstep | `workstep_link` |
| part on off | `wo_part_on_off` |

### Pickslip & Order
| Keyword | Bảng |
|---------|------|
| pickslip | `pickslip_header`, `pickslip_detail` |
| order | `od_header`, `od_detail` |
| order detail | `od_detail` |
| order header | `od_header` |

### Work Package
| Keyword | Bảng |
|---------|------|
| work package, WP | `wp_header`, `wp_history` |
| wp history | `wp_history` |

### Parts
| Keyword | Bảng |
|---------|------|
| part | `part_*` (100+ bảng) |
| rotable | `rotable_*` |
| stock | `stock_*` |
| inventory | `inventory_*` |

### Staff
| Keyword | Bảng |
|---------|------|
| staff, employee | `sign`, `staff_*` |
| qualification, PQS | `staff_pqs_qualification` |
| resource | `resource_*` |

### Aircraft
| Keyword | Bảng |
|---------|------|
| aircraft, AC | `ac_*`, `aircraft` |
| flight | `ac_future_flights`, `ac_frozen_flights` |
| utilization | `ac_utilization` |

## 📝 Lưu ý

1. **DATE_INT**: Tất cả cột ngày tháng trong AMOS là INTEGER (DATE_INT)
   - Mốc: `1971-12-31`
   - Xem [QUERY_PATTERNS.md](./QUERY_PATTERNS.md) để biết cách xử lý

2. **Primary Keys**: Hầu hết bảng có PK là `*no_i` (integer)

3. **Foreign Keys**: Thường là `*no_i` hoặc `event_perfno_i`

4. **Status columns**: Nhiều bảng có cột `status` với ý nghĩa khác nhau

## 🔗 Liên kết

- [TABLE_REFERENCE.md](./TABLE_REFERENCE.md) - Chi tiết các bảng chính
- [QUERY_PATTERNS.md](./QUERY_PATTERNS.md) - Pattern query thường dùng
- [vietjet_amos_schema.sql](./vietjet_amos_schema.sql) - Schema đầy đủ (71,000+ dòng)
- [INDEX.md](./INDEX.md) - Index các query
- [KEYWORD_MAPPING.md](./KEYWORD_MAPPING.md) - Mapping từ khóa

## 📊 Thống kê

- **Tổng số bảng**: 2,141
- **Work Order & Jobcard**: 100+ bảng
- **Pickslip & Order**: 60+ bảng
- **Work Package**: 10+ bảng
- **Aircraft**: 35 bảng
- **Parts & Inventory**: 100+ bảng
- **Staff & Resource**: 50+ bảng
- **Address & Vendor**: 29 bảng
- **Maintenance Program**: 68 bảng
- **A2A**: 4 bảng
- **Aero Repair**: 13 bảng
- **Forecast**: 11 bảng
- **Other**: 1,589 bảng

---

**⭐ = Bảng quan trọng - Xem [TABLE_REFERENCE.md](./TABLE_REFERENCE.md) để biết chi tiết**
