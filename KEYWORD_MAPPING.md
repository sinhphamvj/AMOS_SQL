# 🔑 Keyword Mapping - Ánh xạ Từ khóa

Mapping các từ khóa trong ngôn ngữ tự nhiên với các query/pattern tương ứng.

## 📋 Work Order (WO)

| Từ khóa | Pattern/Query | File tham khảo |
|---------|---------------|----------------|
| WO đang mở, WO chưa đóng, open WO | Pattern 3 | `daily report/wooverdue.sql` |
| WO đã đóng, closed WO | Pattern 4 | `daily report/woclosedbyAM.sql` |
| WO quá hạn, overdue WO | Pattern 2 + Pattern 3 | `daily report/wo_over_due_ver01.sql` |
| WO AOG, aircraft on ground | - | `daily report/get_wo_aog.sql` |
| WO theo máy bay, WO by aircraft | Pattern 5 | - |
| WO có MEL, MEL WO | Pattern 6 | `ADD_SHEET/MCC_OPEN_MEL.SQL` |
| WO trong 7 ngày, 7D WO | - | `maint_control/ADD_7D_WO.SQL` |
| WO schedule, lịch WO | - | `daily report/woschedule.sql` |
| WO OPS limit | - | `daily report/wo_opslimit.sql` |
| WO reference, chi tiết WO | - | `ADD_SHEET/WO_Reference_Details.sql` |

## 🎫 Jobcard

| Từ khóa | Pattern/Query | File tham khảo |
|---------|---------------|----------------|
| Jobcard, JC | Pattern 7 | `reference_queries/get_all_jobcards.sql` ⭐ |
| Tất cả jobcard, all jobcard | Pattern 7 | `reference_queries/get_all_jobcards.sql` ⭐ |
| Jobcard có WO đã đóng | Pattern 9 | `reference_queries/get_all_jobcards.sql` ⭐ |
| Jobcard có WO đã đóng trong N ngày | Pattern 9 + Pattern 2 | `reference_queries/get_all_jobcards.sql` ⭐ |
| Tên jobcard, jobcard name | Pattern 8 | `reference_queries/get_all_jobcards.sql` ⭐ |
| Parse WO từ jobcard | Pattern 8 | `reference_queries/get_all_jobcards.sql` ⭐ |
| Jobcard template | Pattern 8 | `reference_queries/get_all_jobcards.sql` ⭐ |

**⭐ = Query Reference (đã xác nhận chính xác)**

## 📦 Work Package (WP)

| Từ khóa | Pattern/Query | File tham khảo |
|---------|---------------|----------------|
| WP hàng ngày, daily WP | Pattern 13 | `wp/daily_list.sql` |
| WP theo máy bay | Pattern 13 | - |
| WP statistics, thống kê WP | Pattern 20 | `DLYWP_DB/PCD_WP_MAIN_STATISTICS.SQL` |
| WP task list | - | `wp/tasklist_manhours.sql` |
| WP defer, WP bị defer | - | `wp/defer.sql` |
| WP feedback | - | `wp/feedback_list.sql` |
| WP ground time | - | `wp/get_groundtime.sql` |
| WP AOG | - | `wp/AOG_WP_STATISTICS.SQL` |
| WP thiếu daily check, chưa assign daily check, OWP chưa có daily check | NOT EXISTS pattern | `wp/check_wp_missing_daily_check.sql` ⭐ |
| Ground time WP, tính ground time, qua đêm | Ground time formula | `wp/check_wp_missing_daily_check.sql` ⭐ |

## 🔩 Phụ tùng (Parts)

| Từ khóa | Pattern/Query | File tham khảo |
|---------|---------------|----------------|
| Part on/off, part thay | Pattern 17 | `part_hangar/not_booking.sql` |
| Part pooling | - | `part_pooling/part_pooling.sql` |
| Part no-go, part không đi | - | `part_pooling/part_nogo.sql` |
| Part hangar | - | `part_hangar/get_part_hg.sql` |
| Part not booking | Pattern 17 | `part_hangar/not_booking.sql` |
| Pickslip | - | `part_hangar/pickslip.sql` |
| Pickslip lọc theo ngày, pickslip từ hôm qua | Pattern 2 | `reference_queries/example_pickslip_yesterday_to_today.sql` ⭐ |
| Lọc pickslip trong N ngày | Pattern 2 | `reference_queries/example_pickslip_yesterday_to_today.sql` ⭐ |
| Part forecast | - | `part_pooling/part_forecast.sql` |

## 👥 Nhân sự (Staff/Resource)

| Từ khóa | Pattern/Query | File tham khảo |
|---------|---------------|----------------|
| Resource online | Pattern 16 | `resource/counter_resource_online.sql` |
| Resource theo station | Pattern 15 | `resource/*_RESOURCE.SQL` |
| Manpower, MPWR | Pattern 15, 16 | `resource/MPWR_*.sql` |
| Staff, nhân viên | Pattern 15 | `staff/get_user.sql` |
| PQS, qualification | - | `staff/get_pqs_class.sql` |
| Resource dashboard | Pattern 15 | `resource/*_resource_dashboard.sql` |

## 📊 Dashboard & Báo cáo

| Từ khóa | Pattern/Query | File tham khảo |
|---------|---------------|----------------|
| Dashboard | - | `dashboard/` |
| Báo cáo hàng ngày, daily report | Pattern 2 | `daily report/` |
| AC count, đếm máy bay | Pattern 19 | `dashboard/Ac_count.sql` |
| Statistics, thống kê | Pattern 18, 19, 20 | - |
| Counter, đếm | Pattern 18 | - |

## 📅 Ngày tháng

| Từ khóa | Pattern/Query | File tham khảo |
|---------|---------------|----------------|
| Chuyển đổi ngày, convert date | Pattern 1 | Hiển thị: `DATE '1971-12-31' + date_column` |
| Lọc theo ngày, filter by date | Pattern 2 | So sánh: `(current_timestamp::date - '1971-12-31'::date)` |
| Từ hôm qua đến hôm nay | Pattern 2 | `BETWEEN ((date_trunc('day', current_timestamp) - interval '1 day')::date - '1971-12-31'::date) AND (current_timestamp::date - '1971-12-31'::date)` |
| Lọc theo ngày, filter by date | Pattern 2 | - |
| Khoảng thời gian, date range | Pattern 2 | - |
| Tháng này, this month | Pattern 2 | - |
| DATE_INT, AMOS date | Pattern 1 | - |

## 🔗 Join & Liên kết

| Từ khóa | Pattern/Query | File tham khảo |
|---------|---------------|----------------|
| Join WO với thông tin bổ sung | Pattern 10 | - |
| Join WO với description | Pattern 11 | `ADD_SHEET/MCC_OPEN_MEL.SQL` |
| Join qua db_link | Pattern 12 | `ADD_SHEET/ADD_UNSPECIFIEDREV2.sql` |
| Liên kết WO và Jobcard | Pattern 12 | - |

## 📋 E-Expansion Sheet (CAAV/FSSD)

| Từ khóa | Pattern/Query | File tham khảo |
|---------|---------------|----------------|
| CAAV, PEL, Form 542, Personnel Licensing | - | `E-expsheet/PEL542-1.sql` |
| FSSD, Form 008, Staff certification | - | `E-expsheet/FSSD008-SECTION-I.sql` |
| FSSD Section III | - | `E-expsheet/FSSD008-SECTION-III.sql` |
| FSSD relative | - | `E-expsheet/FSSD008-RELATIVE.SQL` |
| E-expansion sheet, expansion sheet | - | `E-expsheet/` |

## 🎯 Các từ khóa đặc biệt

### MEL/OPS
- **MEL**: `mel_code`, `mel_chapter` → Pattern 6
- **OPS limit**: `OPSLIMIT`, `OPS_FILTER` → `ADD_SHEET/OPSLIMIT.SQL`
- **ADD Sheet**: `ADD_SHEET/`

### Trạng thái
- **Open/O**: `state = 'O'` → Pattern 3
- **Closed/C**: `state = 'C'` → Pattern 4
- **Active**: `status = 0`

### Loại WO
- **Maintenance/M**: `type = 'M'`
- **Pirep/P**: `type = 'P'`
- **Cabin/C**: `type = 'C'`
- **Scheduled/S**: `type = 'S'`
- **Pending/PD**: `type = 'PD'`

### Station
- **SGN**: `location = 'SGN'` hoặc `homebase = 'SGN'`
- **HAN**: `location = 'HAN'` hoặc `homebase = 'HAN'`
- **DAD, HPH, VCA, CXR, PQC**: Tương tự

## 🔍 Cách sử dụng

Khi người dùng mô tả bằng ngôn ngữ tự nhiên:

1. **Xác định từ khóa chính**: Tìm trong bảng trên
2. **Xác định pattern tương ứng**: Xem Pattern trong [QUERY_PATTERNS.md](./QUERY_PATTERNS.md)
3. **Tìm file tham khảo**: Xem file SQL tương ứng
4. **Kết hợp các pattern**: Nếu cần nhiều điều kiện

### Ví dụ

**Câu hỏi**: "Lấy tất cả jobcard có WO đã đóng"

1. Từ khóa: "jobcard", "WO đã đóng"
2. Pattern: Pattern 7 (Jobcard) + Pattern 4 (WO đã đóng) → Pattern 9
3. File: `get_all_jobcards.sql`
4. Kết quả: Sử dụng Pattern 9

**Câu hỏi**: "Lấy WO đang mở của máy bay VN-A123 trong tháng này"

1. Từ khóa: "WO đang mở", "máy bay", "tháng này"
2. Pattern: Pattern 3 (WO đang mở) + Pattern 5 (theo máy bay) + Pattern 2 (tháng này)
3. Kết hợp: Pattern 3 + Pattern 5 + Pattern 2

## 📚 Xem thêm

- [QUERY_TABLE_COLUMN_USAGE.md](./QUERY_TABLE_COLUMN_USAGE.md) ⭐⭐⭐ - Phân tích table/column từ 131 queries thực tế
- [MEMORY_BANK.md](./MEMORY_BANK.md) ⭐⭐ - Kiến thức và insights từ phân tích queries
- [Query Patterns](./QUERY_PATTERNS.md) - Chi tiết các pattern
- [Table Reference](./TABLE_REFERENCE.md) - Tham chiếu bảng
- [Schema SQL](./vietjet_amos_schema.sql) - Schema đầy đủ database
- [Index](./INDEX.md) - Danh mục query

