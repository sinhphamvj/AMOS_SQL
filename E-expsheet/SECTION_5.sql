SELECT 
    b.event_perfno_i,
    TRIM(SUBSTRING(b.text FROM 'AC:\s*([A-Z0-9-]+)')) AS "AC",
    TRIM(SUBSTRING(b.text FROM 'WP:\s*([A-Z0-9-]+)')) AS "WP",
    b.extracted_wo_id AS "WO",
    TRIM(SUBSTRING(b.text FROM 'MAINTENANCE RECORD:\s*(.*)$')) AS "MAINT RECORD",
    dl.classification AS "CAT",
    b.text,
    b.created_by,
    TO_CHAR(DATE '1971-12-31' + b.created_date, 'DD.MON.YYYY') AS "CREATED_DATE",
    b.other as "MHR",
    CAST(REPLACE(wt.template_number, ',', '.') AS NUMERIC) AS "ID",
    dl.ref_type AS "TASK_TYPE",
    dl.description AS "TASK_REFERENCE",
    dl.link_remarks AS "TASK_DESCRIPTION",
    b."REMARKS"
FROM (
    -- BƯỚC 1: Lấy số liệu nền, lọc ngay lập tức từ lúc truy vấn gốc bắt đầu
    -- Cắt Regex tại đây 1 lần để giảm vòng lặp Regex thừa của CPU
    SELECT 
        wo_header.event_perfno_i,
        wo_header.template_revisionno_i,
        wo_text_description.text,
        wo_text_description.created_by,
        wo_text_description.desc_comment AS "REMARKS",
        wo_text_description.created_date,
        wp_header.wpno_i,
        wo_header_more.other,
        -- Chuyển số WO lấy được sang SỐ NGUYÊN luôn
        -- Dùng Regex để bắt đúng phần số nguyên sau "WO:", tránh lấy thừa ký tự
        CAST(
            NULLIF(
                -- Bước 1: Xóa backtick (CHR(96)) ra khỏi text bằng REPLACE
                -- Bước 2: SUBSTRING bắt duy nhất CÁC CHỮ SỐ [0-9]+ ngay sau WO:
                -- Nếu có dạng 10592432.00 hoặc 10592432 WP:, Regex sẽ dừng tự động ngay trước dấu chấm/khoảng trắng.
                SUBSTRING(
                    REPLACE(wo_text_description.text, CHR(96), '')
                    FROM 'WO:\s*([0-9]+)'
                ),
                ''
            )
        AS BIGINT) AS extracted_wo_id
    FROM wp_header
    JOIN wp_assignment ON wp_header.wpno_i = wp_assignment.wpno_i
    JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i
    LEFT JOIN wo_header_more ON wo_header_more.event_perfno_i = wo_header.event_perfno_i
    JOIN wo_text_description ON wo_text_description.descno_i = workstep_link.descno_i
    WHERE 
        -- Bộ chốt ID của bạn (sẽ làm tập query nhỏ đi ngay lập tức trước khi chạy subquery)
        wp_header.wpno LIKE '%EXP-VJC2741%'
        AND wo_header.event_type = 'JC'
        AND wo_header.state = 'C'
        
) b
LEFT JOIN event_template et ON b.template_revisionno_i = et.template_revisionno_i
LEFT JOIN work_template wt ON et.wtno_i = wt.wtno_i
LEFT JOIN db_link dl ON et.event_perfno_i::VARCHAR = dl.source_pk 
                    AND dl.source_type = 'WO'
WHERE EXISTS (
     SELECT 1
     FROM wo_text_action wta
     -- Đưa tất cả điều kiện JOIN vào ON để SQL Engine dễ thiết lập sơ đồ cây (Plan Tree) nhất
     -- Sử dụng alias rõ ràng để chạy Index trên [source_pk, source_type] composite
     JOIN db_link sub_dl ON wta.actionno_i::VARCHAR = sub_dl.source_pk
                        AND sub_dl.source_type = 'WOA'
                        AND sub_dl.ref_type IN ('MEL','AMM','CDL','SRM','NTM','TSM','DOC_REF')
     WHERE 
         -- Sử dụng toán tử `=` số học thuần chuẩn, Database Index sẽ scan thẳng vào
         wta.event_perfno_i = b.extracted_wo_id 
         -- Dù toán tử LIKE này quét hai đầu tốn thời gian, nhưng nó đã được hạ tải tối đa vì
         -- số lượng rows lọt xuống cấp độ này đã bị thu hẹp bởi CTE và JOIN/WHERE bên trên
         AND sub_dl.description LIKE '%' || dl.description || '%'
)
OR
EXISTS (
    SELECT 1
    FROM wp_header 
    LEFT JOIN wp_assignment ON wp_header.wpno_i = wp_assignment.wpno_i
    JOIN forecast ON forecast.event_perfno_i = wp_assignment.event_perfno_i
    LEFT JOIN db_link ON forecast.event_perfno_i::VARCHAR =db_link.source_pk AND db_link.source_type = 'WO'AND db_link.ref_type = 'AMTOSS'
    WHERE
    wp_header.wpno LIKE '%' || TRIM(SUBSTRING(b.text FROM 'WP:\s*([A-Z0-9-]+)')) || '%'
    AND forecast.sequence LIKE '%' || TRIM(SUBSTRING(b.text FROM 'MAINTENANCE RECORD:[^0-9]*([0-9]+(?:\.[0-9]+)?)')) || '%'
    AND SUBSTRING(REPLACE(db_link.description, '-', ''), 1, 12) = SUBSTRING(REPLACE(dl.description, '-', ''), 1, 12)
)
ORDER BY "ID"
