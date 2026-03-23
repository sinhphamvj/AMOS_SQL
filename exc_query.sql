-- ============================================================
-- TRUY VẤN LẤY TẤT CẢ JOBCARD CÓ WO ĐÃ ĐÓNG
-- LOẠI TRỪ CÁC JOBCARD CÓ TITLE "REPETITIVE INSPECTION"
-- ============================================================
-- Lấy tất cả jobcard có tên dạng JC-AXXX-YYYYYYYYY
-- Trong đó:
--   - AXXX là mã máy bay (AIRCRAFT_REG)
--   - YYYYYYY là event_perfno_i của WO (không phải workorderno_display)
-- Chỉ lấy các jobcard mà WO của nó đã đóng (state = 'C')
-- Loại trừ các jobcard có title "REPETITIVE INSPECTION"
-- Không giới hạn thời gian (lấy tất cả WO đã đóng)
-- 
-- Logic:
-- 1. Lấy từ work_template với template_type = 'J' và status = 0
-- 2. Parse WO number (event_perfno_i) từ template_number (phần sau dấu gạch ngang cuối cùng)
-- 3. Join với wo_header để tìm WO có event_perfno_i = parsed number và state = 'C'
-- 4. Join với workstep_link và wo_text_description để lấy description
-- 5. Loại trừ WO có "REPETITIVE INSPECTION" trong description
-- 6. Join với wo_header jobcard để lấy thông tin jobcard
-- ============================================================

SELECT 
    -- Tên jobcard từ template
    t.template_number AS "JOBCARD_NAME",
    t.template_title AS "JOBCARD_TITLE",
    -- Thông tin WO
    wo.workorderno_display AS "WO_NUMBER",
    wo.state AS "WO_STATE",
    wo.ac_registr AS "WO_AC_REG",
    wo.closing_date AS "WO_CLOSING_DATE"
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
        AND wo.state = 'C'  -- WO đã đóng (không giới hạn thời gian)
    -- Join với workstep_link để lấy description mới nhất
    LEFT JOIN workstep_link wl ON wo.event_perfno_i = wl.event_perfno_i
        AND wl.sequenceno = (
            SELECT MAX(sequenceno) 
            FROM workstep_link wl2 
            WHERE wl2.event_perfno_i = wo.event_perfno_i
        )
    -- Join với wo_text_description để lấy text
    LEFT JOIN wo_text_description wo_desc ON wl.descno_i = wo_desc.descno_i
    -- Join với wo_header để lấy thông tin jobcard
    LEFT JOIN wo_header jc ON jc.template_revisionno_i = t.wtno_i
        AND jc.event_type = 'JC'
        AND jc.type = 'PD'
        AND jc.event_perfno_i > 0
        AND jc.workorderno_display IS NULL
WHERE
    -- Loại trừ các WO có "REPETITIVE INSPECTION" trong description
    (wo_desc.text IS NULL OR wo_desc.text NOT LIKE '%REPETITIVE INSPECTION%')
ORDER BY 
    wo.closing_date DESC;

