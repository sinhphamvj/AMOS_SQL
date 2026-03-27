SELECT 
    wo_header.event_perfno_i,
    -- Trích xuất cột AC
    TRIM(SUBSTRING(wo_text_description.text FROM 'AC:\s*([A-Z0-9]+)')) AS "AC",
    -- Trích xuất cột WP
    TRIM(SUBSTRING(wo_text_description.text FROM 'WP:\s*([A-Z0-9]+)')) AS "WP",
    -- Trích xuất cột WO
    TRIM(SUBSTRING(wo_text_description.text FROM 'WO:\s*([0-9]+)')) AS "WO",
    -- Trích xuất cột MAINT RECORD
    TRIM(SUBSTRING(wo_text_description.text FROM 'MAINT RECORD:\s*(.*)$')) AS "MAINT RECORD",
    wo_header_more.other AS "CAT",
    wo_text_description.text,
    wo_text_description.created_by,
    wo_text_description.desc_comment AS "REMARKS",
    TO_CHAR(DATE '1971-12-31' + wo_text_description.created_date, 'DD.MON.YYYY') AS "CREATED_DATE",
    work_template.template_number,
    work_template.template_title,
    db_link.description,
    db_link.link_remarks
FROM wp_header
JOIN wp_assignment ON wp_header.wpno_i = wp_assignment.wpno_i
JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i
LEFT JOIN wo_header_more ON wo_header_more.event_perfno_i = wo_header.event_perfno_i
JOIN wo_text_description ON wo_text_description.descno_i = workstep_link.descno_i
LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
LEFT JOIN db_link ON event_template.event_perfno_i::VARCHAR = db_link.source_pk
WHERE 
    wp_header.wpno_i = 136636
    AND wo_header.event_perfno_i = 7970736
    AND EXISTS (
         SELECT 1
         FROM wo_text_action
         LEFT JOIN db_link sub_db_link ON wo_text_action.actionno_i::VARCHAR = sub_db_link.source_pk
         WHERE
             sub_db_link.source_type = 'WOA'
             AND sub_db_link.ref_type IN ('MEL', 'AMM', 'CDL', 'SRM', 'NTM', 'TSM', 'DOC_REF')
             AND sub_db_link.description LIKE '%' || db_link.description || '%'
             AND wo_text_action.event_perfno_i::VARCHAR = TRIM(SUBSTRING(wo_text_description.text FROM 'WO:\s*([0-9]+)'))
     )