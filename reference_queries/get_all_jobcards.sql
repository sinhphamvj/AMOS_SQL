-- ============================================================
-- TRUY VẤN LẤY JOBCARD CÓ WO ĐÃ ĐÓNG TRONG 30 NGÀY QUA
-- ============================================================
-- Lấy tất cả jobcard có tên dạng JC-AXXX-YYYYYYYYY
-- Trong đó:
--   - AXXX là mã máy bay (AIRCRAFT_REG)
--   - YYYYYYY là event_perfno_i của WO (không phải workorderno_display)
-- Chỉ lấy các jobcard mà WO của nó đã đóng (state = 'C')
-- và WO đóng trong vòng 30 ngày trước (từ thời điểm hiện tại trở về trước 30 ngày)
-- 
-- Logic:
-- 1. Lấy từ work_template với template_type = 'J' và status = 0
-- 2. Parse WO number (event_perfno_i) từ template_number (phần sau dấu gạch ngang cuối cùng)
-- 3. Join với wo_header để tìm WO có event_perfno_i = parsed number và state = 'C'
-- 4. Lọc WO đóng trong vòng 30 ngày: closing_date BETWEEN (30 ngày trước) AND (hôm nay)
-- 5. Join với wo_header jobcard để lấy thông tin jobcard
-- ============================================================

SELECT 
    jc.event_perfno_i AS "JOBCARD_ID",
    jc.ac_registr AS "AIRCRAFT_REG",
    jc.ata_chapter AS "ATA_CHAPTER",
    jc.state AS "JOBCARD_STATE",
    jc.issue_date AS "JOBCARD_ISSUE_DATE",
    jc.issue_station AS "JOBCARD_ISSUE_STATION",
    -- Tên jobcard từ template
    t.template_number AS "JOBCARD_NAME",
    t.template_title AS "JOBCARD_TITLE",
    -- WO number được parse từ tên jobcard (event_perfno_i)
    t.extracted_wono AS "WO_EVENT_PERFNO_I",
    -- Thông tin WO
    wo.workorderno_display AS "WO_NUMBER",
    wo.event_perfno_i AS "WO_ID",
    wo.state AS "WO_STATE",
    wo.ac_registr AS "WO_AC_REG",
    wo.issue_date AS "WO_ISSUE_DATE",
    wo.closing_date AS "WO_CLOSING_DATE",
    wo.ata_chapter AS "WO_ATA_CHAPTER"
FROM 
    (
        SELECT
            wt.wtno_i,
            wt.template_title,
            wt.template_number,
            CAST(NULLIF(SPLIT_PART(wt.template_number, '-', 3), '') AS INTEGER) AS extracted_wono
        FROM
            work_template wt
        WHERE
            wt.status = 0
            AND wt.template_type = 'J'
            AND wt.template_number ~ '^JC-[^-]+-[0-9]+$'
    ) AS t
    -- Join với wo_header để tìm WO tương ứng (WO đã đóng)
    INNER JOIN wo_header wo ON t.extracted_wono = wo.event_perfno_i
        AND wo.state = 'C'  -- WO đã đóng
        -- Lọc WO đóng trong vòng 30 ngày trước (từ thời điểm hiện tại trở về trước 30 ngày)
        -- Để thay đổi số ngày, thay '30 days' bằng số ngày mong muốn (ví dụ: '7 days', '60 days')
        AND wo.closing_date BETWEEN
            ((date_trunc('day', current_timestamp) - interval '30 days')::date - '1971-12-31'::date)
            AND (current_timestamp::date - '1971-12-31'::date)
    -- Join với wo_header để lấy thông tin jobcard
    LEFT JOIN wo_header jc ON jc.template_revisionno_i = t.wtno_i
        AND jc.event_type = 'JC'
        AND jc.type = 'PD'
        AND jc.event_perfno_i > 0
        AND jc.workorderno_display IS NULL
ORDER BY 
    wo.closing_date DESC;

-- ============================================================
-- PHIÊN BẢN MỞ RỘNG: LẤY JOBCARD KÈM THÔNG TIN BỔ SUNG
-- ============================================================
-- Bỏ comment dòng dưới để sử dụng query này:
-- Nếu cần thêm thông tin từ các bảng liên quan

-- SELECT 
--     wo_header.event_perfno_i AS "JOBCARD_ID",
--     wo_header.ac_registr AS "AIRCRAFT_REG",
--     wo_header.ata_chapter AS "ATA_CHAPTER",
--     wo_header.state AS "STATE",
--     wo_header.issue_date AS "ISSUE_DATE",
--     wo_header.issue_station AS "ISSUE_STATION",
--     wo_header.closing_date AS "CLOSING_DATE",
--     wo_header.mel_code AS "MEL_CODE",
--     wo_header_more.wo_class AS "WO_CLASS",
--     wo_header_more.mel_chapter AS "MEL_CHAPTER",
--     work_template.template_number AS "TEMPLATE_NUMBER",
--     work_template.template_title AS "TEMPLATE_TITLE",
--     work_template.template_type AS "TEMPLATE_TYPE",
--     work_template.preparation AS "PREPARATION"
-- FROM 
--     wo_header
--     LEFT JOIN wo_header_more ON wo_header.event_perfno_i = wo_header_more.event_perfno_i
--     LEFT JOIN work_template ON wo_header.template_revisionno_i = work_template.wtno_i
-- WHERE 
--     wo_header.event_type = 'JC'
--     AND wo_header.type = 'PD'
--     AND wo_header.event_perfno_i > 0
--     AND wo_header.workorderno_display IS NULL
-- ORDER BY 
--     wo_header.event_perfno_i DESC;

-- ============================================================
-- PHIÊN BẢN LỌC THEO TRẠNG THÁI
-- ============================================================
-- Bỏ comment dòng dưới để lấy chỉ jobcard đang mở (Open):

-- SELECT 
--     wo_header.event_perfno_i AS "JOBCARD_ID",
--     wo_header.ac_registr AS "AIRCRAFT_REG",
--     wo_header.ata_chapter AS "ATA_CHAPTER",
--     wo_header.issue_date AS "ISSUE_DATE",
--     wo_header.issue_station AS "ISSUE_STATION"
-- FROM 
--     wo_header
-- WHERE 
--     wo_header.event_type = 'JC'
--     AND wo_header.type = 'PD'
--     AND wo_header.event_perfno_i > 0
--     AND wo_header.workorderno_display IS NULL
--     AND wo_header.state = 'O'
-- ORDER BY 
--     wo_header.issue_date DESC;

-- ============================================================
-- PHIÊN BẢN LỌC THEO MÁY BAY
-- ============================================================
-- Bỏ comment và thay '@ACReg@' bằng mã máy bay cụ thể (ví dụ: 'VN-A123'):

-- SELECT 
--     wo_header.event_perfno_i AS "JOBCARD_ID",
--     wo_header.ac_registr AS "AIRCRAFT_REG",
--     wo_header.ata_chapter AS "ATA_CHAPTER",
--     wo_header.state AS "STATE",
--     wo_header.issue_date AS "ISSUE_DATE",
--     wo_header.closing_date AS "CLOSING_DATE"
-- FROM 
--     wo_header
-- WHERE 
--     wo_header.event_type = 'JC'
--     AND wo_header.type = 'PD'
--     AND wo_header.event_perfno_i > 0
--     AND wo_header.workorderno_display IS NULL
--     AND wo_header.ac_registr = 'VN-A123'  -- Thay bằng mã máy bay thực tế
-- ORDER BY 
--     wo_header.issue_date DESC;

-- ============================================================
-- TRUY VẤN LẤY JOBCARD CÓ WO ĐÃ ĐÓNG
-- VÀ WO CÓ "REPETITIVE INSPECTION" TRONG TITLE/DESCRIPTION
-- ============================================================
-- Lấy tất cả jobcard có tên dạng JC-AXXX-YYYYYYYYY
-- Trong đó:
--   - AXXX là mã máy bay (AIRCRAFT_REG)
--   - YYYYYYY là event_perfno_i của WO (không phải workorderno_display)
-- Chỉ lấy các jobcard mà WO của nó đã đóng (state = 'C')
-- và WO có "REPETITIVE INSPECTION" trong title/description
-- Không giới hạn thời gian (lấy tất cả WO đã đóng)
-- 
-- Logic:
-- 1. Lấy từ work_template với template_type = 'J' và status = 0
-- 2. Parse WO number (event_perfno_i) từ template_number (phần sau dấu gạch ngang cuối cùng)
-- 3. Join với wo_header để tìm WO có event_perfno_i = parsed number và state = 'C'
-- 4. Join với workstep_link và wo_text_description để lấy description
-- 5. Lọc WO có "REPETITIVE INSPECTION" trong description
-- 6. Join với wo_header jobcard để lấy thông tin jobcard
-- ============================================================

-- SELECT 
--     -- Tên jobcard từ template
--     t.template_number AS "JOBCARD_NAME",
--     t.template_title AS "JOBCARD_TITLE",
--     -- Thông tin WO
--     wo.workorderno_display AS "WO_NUMBER",
--     wo.state AS "WO_STATE",
--     wo.ac_registr AS "WO_AC_REG",
--     wo.closing_date AS "WO_CLOSING_DATE"
-- FROM 
--     (
--         SELECT
--             wt.wtno_i,
--             wt.template_title,
--             wt.template_number,
--             CAST(NULLIF(SPLIT_PART(wt.template_number, '-', 3), '') AS INTEGER) AS extracted_wono
--         FROM
--             work_template wt
--         WHERE
--             wt.status = 0
--             AND wt.template_type = 'J'
--             AND wt.template_number ~ '^JC-[^-]+-[0-9]+$'
--     ) AS t
--     -- Join với wo_header để tìm WO tương ứng (WO đã đóng)
--     INNER JOIN wo_header wo ON t.extracted_wono = wo.event_perfno_i
--         AND wo.state = 'C'  -- WO đã đóng (không giới hạn thời gian)
--     -- Join với workstep_link để lấy description mới nhất
--     INNER JOIN workstep_link wl ON wo.event_perfno_i = wl.event_perfno_i
--         AND wl.sequenceno = (
--             SELECT MAX(sequenceno) 
--             FROM workstep_link wl2 
--             WHERE wl2.event_perfno_i = wo.event_perfno_i
--         )
--     -- Join với wo_text_description để lấy text
--     INNER JOIN wo_text_description wo_desc ON wl.descno_i = wo_desc.descno_i
--         -- Lọc WO có "REPETITIVE INSPECTION" trong description
--         AND wo_desc.text LIKE '%REPETITIVE INSPECTION%'
--     -- Join với wo_header để lấy thông tin jobcard
--     LEFT JOIN wo_header jc ON jc.template_revisionno_i = t.wtno_i
--         AND jc.event_type = 'JC'
--         AND jc.type = 'PD'
--         AND jc.event_perfno_i > 0
--         AND jc.workorderno_display IS NULL
-- ORDER BY 
--     wo.closing_date DESC;

