# 📑 Index - Danh mục Query theo Chức năng

## 📚 Ví dụ mẫu & Reference Queries
| Query | Mô tả | File |
|-------|-------|------|
| Pickslip từ hôm qua đến hôm nay (Reference) | Ví dụ mẫu về cách lọc theo ngày AMOS | `reference_queries/example_pickslip_yesterday_to_today.sql` ⭐ |
| Jobcard có WO đã đóng (Reference) | Query mẫu chính xác - Parse WO từ jobcard, lọc theo thời gian | `reference_queries/get_all_jobcards.sql` ⭐ |

**⭐ = Query Reference (đã xác nhận chính xác) - Xem [reference_queries/README.md](./reference_queries/README.md)**

## 🔍 Tìm kiếm nhanh

### Work Order (WO)
| Query | Mô tả | File |
|-------|-------|------|
| WO đang mở | WO chưa đóng | `daily report/wooverdue.sql` |
| WO đã đóng | WO đã đóng bởi AM | `daily report/woclosedbyAM.sql` |
| WO AOG | WO AOG (Aircraft On Ground) | `daily report/get_wo_aog.sql` |
| WO overdue | WO quá hạn | `daily report/wo_over_due_ver01.sql` |
| WO schedule | WO theo lịch | `daily report/woschedule.sql` |
| WO OPS limit | WO có OPS limit | `daily report/wo_opslimit.sql` |
| WO reference | Chi tiết reference của WO | `ADD_SHEET/WO_Reference_Details.sql` |
| WO last workstep | Workstep cuối của WO | `ADD_SHEET/wo_last_workstep.sql` |
| WO 7D | WO trong 7 ngày | `maint_control/ADD_7D_WO.SQL` |
| WO 7D cols | Thêm cột 7D cho WO | `maint_control/ADD_7D_WO_COLS.SQL` |
| Next Due 7D | Next Due trong 7 ngày | `maint_control/ADD_NEXT_DUE_7D.SQL` |

### Jobcard
| Query | Mô tả | File |
|-------|-------|------|
| Tất cả jobcard | Lấy tất cả jobcard | `reference_queries/get_all_jobcards.sql` ⭐ |
| Jobcard có WO đã đóng | Jobcard mà WO tương ứng đã đóng (trong khoảng thời gian) | `reference_queries/get_all_jobcards.sql` ⭐ |
| Jobcard có WO đã đóng + REPETITIVE INSPECTION | Jobcard có WO đã đóng trong 1 năm + có "REPETITIVE INSPECTION" | `exc_query.sql` |

**⭐ = Query Reference (đã xác nhận chính xác)**

### Work Package (WP)
| Query | Mô tả | File |
|-------|-------|------|
| WP daily list | Danh sách WP hàng ngày | `wp/daily_list.sql` |
| WP task list | Danh sách task trong WP | `wp/tasklist_manhours.sql` |
| WP statistics | Thống kê WP | `DLYWP_DB/PCD_WP_MAIN_STATISTICS.SQL` |
| WP station statistics | Thống kê WP theo station | `DLYWP_DB/PCD_WP_STATICTIS_FOR_EACH_STATION.SQL` |
| WP daily count | Đếm WP hàng ngày | `DLYWP_DB/PCD_WP_DAILY_COUNT.SQL` |
| WP weekly count | Đếm WP hàng tuần | `DLYWP_DB/PCD_WEEKY_COUNT.sql` |
| WP task list | Danh sách task WP | `DLYWP_DB/PCD_WP_TASK_LIST.sql` |
| WP defer | WP bị defer | `wp/defer.sql`, `wp/defer_list.sql` |
| WP feedback | Feedback WP | `wp/feedback_list.sql` |
| WP ground time | Ground time của WP | `wp/get_groundtime.sql`, `wp/get_ground_time.sql` |
| WP AOG statistics | Thống kê WP AOG | `wp/AOG_WP_STATISTICS.SQL` |
| WP AOG counter | Đếm WP AOG | `wp/AOG_WP_COUNTER.SQL` |
| WP heavy | WP heavy | `wp/WP_heavy.sql` |
| Check WP | Kiểm tra WP | `wp/check_*.sql` |
| WP thiếu Daily Check ⭐ | Dashboard: OWP/TXWP có ground time ≥ 2h nhưng chưa assign Daily Check WO | `wp/check_wp_missing_daily_check.sql` |

### MEL / OPS
| Query | Mô tả | File |
|-------|-------|------|
| MCC Open MEL | MEL đang mở | `ADD_SHEET/MCC_OPEN_MEL.SQL` |
| Get MEL | Lấy thông tin MEL | `daily report/get_mel.sql` |
| OPS Filter | Lọc OPS | `ADD_SHEET/OPS_FILTER.SQL` |
| OPS Limit | OPS limit | `ADD_SHEET/OPSLIMIT.SQL` |
| OPS Limit RP | OPS limit report | `daily report/OPS_LIMIT_RP.sql` |
| MP OPS | Maintenance Program OPS | `dashboard/MP_OPS.sql` |

### Phụ tùng (Parts)
| Query | Mô tả | File |
|-------|-------|------|
| Part pooling | Quản lý pooling phụ tùng | `part_pooling/part_pooling.sql` |
| Part pooling check | Kiểm tra part pooling | `part_pooling/check_part_pooling.sql` |
| Part no-go | Part không đi được | `part_pooling/part_nogo.sql`, `part_pooling/part_nogo_ver01.sql` |
| Part forecast | Dự báo phụ tùng | `part_pooling/part_forecast.sql` |
| Part hangar | Phụ tùng trong hangar | `part_hangar/get_part_hg.sql` |
| Part hangar check | Kiểm tra part hangar | `part_hangar/check_part_hagar.sql` |
| Part not booking | Part chưa booking | `part_hangar/not_booking.sql` |
| Pickslip | Pickslip | `part_hangar/pickslip.sql`, `part_pooling/pickslip_detail.sql` |
| Pickslip lọc theo ngày (Reference) | Ví dụ mẫu lọc pickslip theo khoảng thời gian | `reference_queries/example_pickslip_yesterday_to_today.sql` ⭐ |
| MOC part request | Yêu cầu part từ MOC | `part_pooling/moc_part_request.sql` |
| Approve control board | Phê duyệt control board | `part_pooling/approve_control_board.sql` |

### Nhân sự (Staff/Resource)
| Query | Mô tả | File |
|-------|-------|------|
| Resource online | Resource đang online | `resource/counter_resource_online.sql` |
| Resource counter | Đếm resource | `resource/resource_counter*.sql` |
| Resource dashboard | Dashboard resource | `resource/*_resource_dashboard.sql` |
| Resource by station | Resource theo station | `resource/*_RESOURCE.SQL` |
| MPWR online | Manpower online | `resource/MPWR_online.sql`, `resource/MPWR_ONLINE_LIST.sql` |
| MPWR monthly | Manpower hàng tháng | `resource/MPWR_MONTHLY.sql` |
| MPWR PQS | Manpower PQS | `resource/MPWR_PQS.sql` |
| MPWR user | Manpower user | `resource/MPWR_USER.sql` |
| Staff user | Thông tin user | `staff/get_user.sql` |
| Staff PQS class | PQS class | `staff/get_pqs_class.sql` |
| Staff user class | User class | `staff/get_user_class.sql` |
| Staff monthly | Staff hàng tháng | `staff/get_mpwr_mothly.sql` |
| Staff all station | Staff tất cả station | `staff/mwpr_all_station.sql` |

### Dashboard
| Query | Mô tả | File |
|-------|-------|------|
| Dashboard AMOS Mobile | Dashboard cho AMOS Mobile | `dashboard/dashboardAmosMobile.sql` |
| AC count | Đếm máy bay | `dashboard/Ac_count.sql` |
| AC plan | Kế hoạch máy bay | `dashboard/get_ac_plan.sql` |
| WO overdue MOC | WO quá hạn MOC | `dashboard/wo_overdue_moc.sql` |
| MOPS MP | Maintenance OPS MP | `dashboard/MOPS_MP.sql` |
| MOPS MP SR | Maintenance OPS MP SR | `dashboard/MOPS_MP_SR.sql` |
| DB AMOS Mobile weekly | Database AMOS Mobile hàng tuần | `dashboard/db_amosmobile_weekly.sql` |
| WP thiếu Daily Check ⭐ | OWP/TXWP ground time ≥ 2h chưa có Daily Check | `wp/check_wp_missing_daily_check.sql` |

### Báo cáo hàng ngày
| Query | Mô tả | File |
|-------|-------|------|
| Daily WP | WP hàng ngày | `daily report/daily_wp.sql` |
| Daily check | Kiểm tra hàng ngày | `daily report/dailycheck_Ver01.sql` |
| Report counter | Đếm báo cáo | `daily report/report_counter.sql` |
| Label booking | Booking label | `daily report/labelbooking.sql`, `daily report/labelbooking2.sql` |
| Label booking WO sched | Label booking WO schedule | `daily report/labelbookingwosched.sql` |
| Check label booking | Kiểm tra label booking | `daily report/checklabelbooking.sql` |
| Crosscheck WO maint | Crosscheck WO maintenance | `daily report/crosscheck_wo_maint.sql` |
| Crosscheck WO sched | Crosscheck WO schedule | `daily report/crosscheck_wo_sched.sql` |
| Check WO maint | Kiểm tra WO maintenance | `daily report/check_wo_maint.sql` |
| Get Mhours WP | Manhours WP | `daily report/get_Mhours_wp.sql` |
| Get arr time | Thời gian đến | `daily report/get_arr_time.sql` |
| Defect AW | Defect aircraft | `daily report/defectaw.sql` |
| Diff closing time | Chênh lệch thời gian đóng | `daily report/diff_closingtime.sql`, `daily report/diff_closingtimever01.sql` |
| Request maint to OMC | Yêu cầu bảo trì đến OMC | `daily report/request_maint_to_omc.sql` |
| WR Monitor | Work Request monitor | `daily report/WR_MONITOR.SQL` |
| AMOS Mobile | AMOS Mobile | `daily report/amosmobile.sql` |
| Structure list | Danh sách structure | `daily report/structure_list.sql` |
| Exp | Export | `daily report/exp.sql` |

### ADD Sheet
| Query | Mô tả | File |
|-------|-------|------|
| ADD Unspecified | ADD không xác định | `ADD_SHEET/ADD_UNSPECIFIED.sql`, `ADD_SHEET/ADD_UNSPECIFIEDREV2.sql` |
| Transfer baseline | Transfer baseline | `ADD_SHEET/transfer_baseline.sql` |
| Latest transfer info | Thông tin transfer mới nhất | `ADD_SHEET/latest_transfer_info.sql` |
| Preferred transfers | Transfer ưu tiên | `ADD_SHEET/preferred_transfers.sql` |
| MP Filter | Maintenance Program filter | `ADD_SHEET/MP_FILTER.sql` |

### E-Expansion Sheet (CAAV/FSSD Forms)
| Query | Mô tả | File |
|-------|-------|------|
| CAAV FORM 542 PEL | Personnel Licensing - General Application | `E-expsheet/PEL542-1.sql` |
| FSSD FORM 008 Section I | Staff certification - Section I | `E-expsheet/FSSD008-SECTION-I.sql` |
| FSSD FORM 008 Section III | Staff certification - Section III | `E-expsheet/FSSD008-SECTION-III.sql` |
| FSSD 008 Relative | FSSD 008 relative data query | `E-expsheet/FSSD008-RELATIVE.SQL` |

### Kiểm tra (Check)
| Query | Mô tả | File |
|-------|-------|------|
| Check JC | Kiểm tra Jobcard | `wp/check_jc.sql` |
| Check prio task | Kiểm tra task ưu tiên | `wp/check_prio_task.sql` |
| Check groundtime | Kiểm tra ground time | `wp/check_groundtime.sql` |
| Check auto deassign WP | Kiểm tra auto deassign WP | `wp/check_auto_deasignwp.sql` |

## 🔗 Liên kết nhanh

- [QUERY_TABLE_COLUMN_USAGE.md](./QUERY_TABLE_COLUMN_USAGE.md) ⭐⭐⭐ - Phân tích table/column từ 131 queries thực tế
- [MEMORY_BANK.md](./MEMORY_BANK.md) ⭐⭐ - Kiến thức và insights từ phân tích queries
- [Bảng tham chiếu](./TABLE_REFERENCE.md) - Các bảng database chính
- [Query Patterns](./QUERY_PATTERNS.md) - Các pattern query thường dùng
- [README](./README.md) - Tổng quan

