-- ================================================================================
-- AMOS DB EXPORT QUERIES - SCRIPT LẤY DỮ LIỆU TỪ DB THẬT
-- ================================================================================
-- Hướng dẫn:
-- 1. Chạy từng câu lệnh dưới đây trên AMOS DB thật (Sybase / PostgreSQL thật).
-- 2. Kết xuất kết quả thành file .csv tương ứng.
-- 3. Lưu tất cả file CSV vào thư mục: data_transfer/csv_data/ trên máy của bạn.
--    Ví dụ: data_transfer/csv_data/aircraft.csv, data_transfer/csv_data/wp_header.csv...
-- 4. Định dạng CSV khuyến nghị: Delimiter là dấu phẩy (,), có dòng Header tiêu đề cột.
--
-- Mốc ngày 1 năm trước (Ví dụ tính từ 2026-06-30 là 2025-06-30):
-- Giá trị nguyên AMOS tương ứng là: 19540
-- ================================================================================

-- ================================================================================
-- NHÓM 1: BẢNG MASTER DATA / DANH MỤC / CẤU HÌNH (XUẤT TOÀN BỘ)
-- ================================================================================
-- Chạy các lệnh này và xuất thành file <tên_bảng>.csv tương ứng:

SELECT * FROM aircraft;
SELECT * FROM ac_typ;
SELECT * FROM ata_chapter;
SELECT * FROM location;
SELECT * FROM department;
SELECT * FROM address;
SELECT * FROM position;
SELECT * FROM staff_pqs_type;
SELECT * FROM staff_pqs_class;
SELECT * FROM part;
SELECT * FROM part_description;
SELECT * FROM part_special;
SELECT * FROM measure_unit;
SELECT * FROM event_template;
SELECT * FROM work_template;
SELECT * FROM worktemplate_link;
SELECT * FROM limitation_config;
SELECT * FROM location_type;
SELECT * FROM location_restriction;
SELECT * FROM parameters;
SELECT * FROM rm_property_type;
SELECT * FROM um_conversion;
SELECT * FROM counter_template;
SELECT * FROM counter_definition;
SELECT * FROM action_type;
SELECT * FROM category;
SELECT * FROM condition;
SELECT * FROM consumables;
SELECT * FROM reason;
SELECT * FROM requirement;
SELECT * FROM station;
SELECT * FROM state;
SELECT * FROM scale;
SELECT * FROM special;
SELECT * FROM printer;
SELECT * FROM amm_reference;
SELECT * FROM ipc_reference;
SELECT * FROM extension_reason;
SELECT * FROM service_type;
SELECT * FROM wo_classification;
SELECT * FROM workstep_classification;
SELECT * FROM wp_priority_codes;
SELECT * FROM wp_status;
SELECT * FROM wp_name;
SELECT * FROM user_access;
SELECT * FROM capability;
SELECT * FROM certificate;
SELECT * FROM sign;
SELECT * FROM simulation;
SELECT * FROM tr_course_list;
SELECT * FROM tr_participant_list;
SELECT * FROM account;
SELECT * FROM adr_details;
SELECT * FROM adr_properties;
SELECT * FROM approval_document;
SELECT * FROM area;
SELECT * FROM history;
SELECT * FROM message;
SELECT * FROM rm_resource_constraint;
SELECT * FROM rm_resource_request;
SELECT * FROM rm_resource_requirement;
SELECT * FROM sp_day_entry_type;
SELECT * FROM sp_shift;
SELECT * FROM sp_user_availability;
SELECT * FROM spa_detail;
SELECT * FROM spa_header;
SELECT * FROM web_drive_history;
SELECT * FROM wb_aircraft_link;
SELECT * FROM wo_measurement_def;
SELECT * FROM wo_measurement_item;
SELECT * FROM wo_remarks;
SELECT * FROM rotables;

-- ================================================================================
-- NHÓM 2: BẢNG GIAO DỊCH / TRANSACTIONAL DATA (XUẤT LỌC 1 NĂM QUA)
-- ================================================================================
-- Sử dụng mốc ngày bắt đầu: 19540 (Tương đương 2025-06-30)
-- Xuất thành file <tên_bảng>.csv tương ứng:

-- 1. Nhóm Work Package
SELECT * FROM wp_header WHERE start_date >= 19540;

SELECT * FROM wp_content 
WHERE wpno_i IN (SELECT wpno_i FROM wp_header WHERE start_date >= 19540);

SELECT * FROM wp_assignment 
WHERE wpno_i IN (SELECT wpno_i FROM wp_header WHERE start_date >= 19540);

SELECT * FROM wp_history 
WHERE date_changed >= 19540;

-- 2. Nhóm Work Order & Jobcard
SELECT * FROM wo_header WHERE issue_date >= 19540;

SELECT * FROM wo_header_more 
WHERE event_perfno_i IN (SELECT event_perfno_i FROM wo_header WHERE issue_date >= 19540);

SELECT * FROM wo_event_link 
WHERE event_perfno_i IN (SELECT event_perfno_i FROM wo_header WHERE issue_date >= 19540);

SELECT * FROM wo_transfer_dimension 
WHERE event_perfno_i IN (SELECT event_perfno_i FROM wo_header WHERE issue_date >= 19540);

SELECT * FROM workstep_link 
WHERE event_perfno_i IN (SELECT event_perfno_i FROM wo_header WHERE issue_date >= 19540);

SELECT * FROM wo_text_description 
WHERE descno_i IN (
    SELECT descno_i FROM workstep_link 
    WHERE event_perfno_i IN (SELECT event_perfno_i FROM wo_header WHERE issue_date >= 19540)
);

SELECT * FROM wo_text_action 
WHERE workstep_linkno_i IN (
    SELECT workstep_linkno_i FROM workstep_link 
    WHERE event_perfno_i IN (SELECT event_perfno_i FROM wo_header WHERE issue_date >= 19540)
);

SELECT * FROM db_link 
WHERE (source_type = 'WO' AND source_pk IN (SELECT CAST(event_perfno_i AS VARCHAR) FROM wo_header WHERE issue_date >= 19540))
   OR (source_type = 'WOA' AND source_pk IN (
       SELECT CAST(actionno_i AS VARCHAR) FROM wo_text_action WHERE workstep_linkno_i IN (
           SELECT workstep_linkno_i FROM workstep_link WHERE event_perfno_i IN (
               SELECT event_perfno_i FROM wo_header WHERE issue_date >= 19540
           )
       )
   ));

-- 3. Nhóm Time Captured (Bấm giờ công)
SELECT * FROM time_captured WHERE start_date >= 19540;

SELECT * FROM time_captured_additional 
WHERE wpno_i IN (SELECT wpno_i FROM wp_header WHERE start_date >= 19540);

SELECT * FROM time_captured_history WHERE start_date >= 19540;

-- 4. Nhóm Aircraft Utilization & Operations
SELECT * FROM ac_utilization WHERE start_date >= 19540;
SELECT * FROM counter_value WHERE date >= 19540;
SELECT * FROM ac_future_flights WHERE start_date >= 19540;
SELECT * FROM ac_suspension WHERE start_date >= 19540;
SELECT * FROM ac_mission WHERE start_date >= 19540;
SELECT * FROM fl2_header WHERE start_date >= 19540;
SELECT * FROM fl2_leg WHERE start_date >= 19540;
SELECT * FROM leg_additional WHERE start_date >= 19540;

-- 5. Nhóm Vật tư & Kho bãi (Giao dịch)
SELECT * FROM pickslip_booked WHERE booking_date >= 19540;
SELECT * FROM pickslip_header WHERE issue_date >= 19540;
SELECT * FROM pickslip_detail WHERE pickslipno_i IN (SELECT pickslipno_i FROM pickslip_header WHERE issue_date >= 19540);
SELECT * FROM pickslip_text WHERE pickslipno_i IN (SELECT pickslipno_i FROM pickslip_header WHERE issue_date >= 19540);
SELECT * FROM od_header WHERE issue_date >= 19540;
SELECT * FROM od_detail WHERE orderno_i IN (SELECT orderno_i FROM od_header WHERE issue_date >= 19540);
SELECT * FROM od_rec_detail WHERE rec_date >= 19540;
SELECT * FROM part_forecast WHERE start_date >= 19540;
SELECT * FROM part_location WHERE last_activity_date >= 19540;
SELECT * FROM part_request_2 WHERE req_date >= 19540;
SELECT * FROM part_request_event_inf WHERE event_perfno_i IN (SELECT event_perfno_i FROM wo_header WHERE issue_date >= 19540);

-- 6. Nhóm Forecast
SELECT * FROM forecast WHERE start_date >= 19540;
SELECT * FROM forecast_dimension WHERE event_perfno_i IN (SELECT event_perfno_i FROM forecast WHERE start_date >= 19540);

-- 7. Nhóm Nhật ký kỹ thuật & Logs
SELECT * FROM moc_daily_records WHERE date >= 19540;
SELECT * FROM moc_daily_note WHERE date >= 19540;
SELECT * FROM bohi_changes WHERE date_changed >= 19540;
SELECT * FROM bohi_info WHERE date_changed >= 19540;
SELECT * FROM bohi_version WHERE date_changed >= 19540;

-- 8. Nhóm Staff Qualifications (Nhân sự)
SELECT * FROM staff_pqs_qualification WHERE expiry_date >= 19540;

-- 9. Nhóm Remarks & Values
SELECT * FROM conversation WHERE date_created >= 19540;
SELECT * FROM rm_property_value WHERE parent_date >= 19540;

-- 10. Các bảng bổ sung khác
SELECT * FROM event_effectivity;
SELECT * FROM event_effectivity_link;
SELECT * FROM maint_event_ext_reason;
SELECT * FROM measurement WHERE date >= 19540;
SELECT * FROM part_fa_entity;
SELECT * FROM shipment WHERE ship_date >= 19540;
SELECT * FROM sp_shift_assign WHERE start_date >= 19540;
SELECT * FROM sp_skill_demand WHERE start_date >= 19540;
SELECT * FROM wo_header_4 WHERE issue_date >= 19540;
SELECT * FROM wo_header_crx WHERE issue_date >= 19540;
SELECT * FROM wo_opus WHERE issue_date >= 19540;
SELECT * FROM wo_part_on_off WHERE change_date >= 19540;
SELECT * FROM wo_transfer WHERE transfer_date >= 19540;
