SELECT 
    "ITEM",
    ROW_NUMBER() OVER (ORDER BY "ITEM") AS "SEQ",
    "WO",
    "WPNOI",
    "JC_TEMPLATE_NUM",
    "JC_LINK_WO_NUM",
    "STATION",
    "AC_REG",
    "EVENT_TYPE",
    "STATUS",
    "START_DATE",
    "START_TIME",
    "END_DATE",
    "END_TIME",
    "GROUND_TIME",
    "PRI",
    "DESCRIPTION",
    "ACTION_TAKEN",
    "REASON",
    "REMARKS",
"PERFORM_SIGN"
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY "WO", "WPNOI" ORDER BY CASE WHEN "REASON" IS NOT NULL THEN 1 ELSE 2 END, -- Ưu tiên hàng có REASON
        "ITEM" -- Nếu cả hai đều có hoặc không có REASON, ưu tiên ITEM nhỏ hơn
        ) AS row_num
FROM (
    -- Subquery for wp_assignment
    SELECT
        DISTINCT ON (wp_assignment.event_perfno_i, wp_assignment.wpno_i) 
        ROW_NUMBER() OVER (ORDER BY wp_header.station) AS "ITEM",
        wp_assignment.event_perfno_i AS "WO",
        wp_assignment.wpno_i AS "WPNOI",
        work_template.template_number AS "JC_TEMPLATE_NUM",
        SPLIT_PART(work_template.template_number, '-', 3) AS "JC_LINK_WO_NUM",
        wp_header.station AS "STATION",
        wp_header.ac_registr AS "AC_REG",
        wo_header.event_type AS "EVENT_TYPE",
        wo_header.state AS "STATUS",
        TO_CHAR(DATE '1971-12-31' + wp_header.start_date, 'DD.MON.YYYY') AS "START_DATE",
        TO_CHAR(TIME '00:00' + (wp_header.start_time || ' minutes')::interval, 'HH24:MI') AS "START_TIME",
        TO_CHAR(DATE '1971-12-31' + wp_header.end_date, 'DD.MON.YYYY') AS "END_DATE",
        TO_CHAR(TIME '00:00' + (wp_header.end_time || ' minutes')::interval, 'HH24:MI') AS "END_TIME",
        TO_CHAR(TIME '00:00' + (
            CASE 
                WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
                ELSE wp_header.end_time - wp_header.start_time
            END || ' minutes')::interval, 'HH24:MI') AS "GROUND_TIME",
        wo_header.prio AS "PRI",
        CASE WHEN wo_header.event_type = 'JC' THEN work_template.template_title ELSE COALESCE(wo_text_description.header, 'NIL') END AS "DESCRIPTION",
        CASE WHEN wo_text_description.text IS NULL THEN REGEXP_REPLACE(REGEXP_REPLACE(wo_text_description.text_html, '<[^>]+>', '', 'g'), '&[^;]+;', '', 'g') ELSE wo_text_description.text END AS "ACTION_TAKEN",
        NULL AS "REASON",
        NULL AS "REMARKS",
        wo_header.mech_sign AS "PERFORM_SIGN"
    FROM
        wp_assignment
        JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i 
        JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
        LEFT JOIN wo_header_more ON wp_assignment.event_perfno_i = wo_header_more.event_perfno_i
        JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
        JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
        LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
        LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
    WHERE
        wp_assignment.wpno_i IN (@VAR.WP@)AND        wo_header.state IN ('C','O')
   AND NOT (wo_header.type = 'PD' AND wo_header.event_type = 'Q')
AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
    GROUP BY
        wp_assignment.event_perfno_i,
        wp_assignment.wpno_i,
        event_template.wtno_i,
        work_template.template_number,
        wp_header.station,
        wp_header.ac_registr,
        wo_header.event_type,
        wo_header.state,
        wp_header.start_date,
        wp_header.start_time,
        wp_header.end_date,
        wp_header.end_time,
        wo_header.prio,
        wo_text_description.header,
        wo_text_description.text,
        wo_text_description.text_html,
        work_template.template_title,
        wo_header.mech_sign
    UNION ALL
    
    -- Subquery for wp_content
    SELECT
        DISTINCT ON (wp_content.event_perfno_i, wp_content.wpno_i) 
        ROW_NUMBER() OVER (ORDER BY wp_header.station) AS "ITEM",
        wp_content.event_perfno_i AS "WO",
        wp_content.wpno_i AS "WPNOI",
        work_template.template_number AS "JC_TEMPLATE_NUM",
        SPLIT_PART(work_template.template_number, '-', 3) AS "JC_LINK_WO_NUM",
        wp_header.station AS "STATION",
        wp_header.ac_registr AS "AC_REG",
        wo_header.event_type AS "EVENT_TYPE",
        wo_header.state AS "STATUS",
        TO_CHAR(DATE '1971-12-31' + wp_header.start_date, 'DD.MON.YYYY') AS "START_DATE",
        TO_CHAR(TIME '00:00' + (wp_header.start_time || ' minutes')::interval, 'HH24:MI') AS "START_TIME",
        TO_CHAR(DATE '1971-12-31' + wp_header.end_date, 'DD.MON.YYYY') AS "END_DATE",
        TO_CHAR(TIME '00:00' + (wp_header.end_time || ' minutes')::interval, 'HH24:MI') AS "END_TIME",
        TO_CHAR(TIME '00:00' + (
            CASE 
                WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
                ELSE wp_header.end_time - wp_header.start_time
            END || ' minutes')::interval, 'HH24:MI') AS "GROUND_TIME",
        wo_header.prio AS "PRI",
        CASE WHEN wo_header.event_type = 'JC' THEN work_template.template_title ELSE COALESCE(wo_text_description.header, 'NIL') END AS "DESCRIPTION",
        CASE WHEN wo_text_description.text IS NULL THEN REGEXP_REPLACE(REGEXP_REPLACE(wo_text_description.text_html, '<[^>]+>', '', 'g'), '&[^;]+;', '', 'g') ELSE wo_text_description.text END AS "ACTION_TAKEN",
        maint_event_ext_reason.description AS "REASON",
        CASE WHEN wp_content.remarks IS NULL OR wp_content.remarks = '' THEN 'NIL' ELSE wp_content.remarks END AS "REMARKS",
        wp_content.created_by AS "PERFORM_SIGN"

    FROM
        wp_content
        JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i 
        JOIN wo_header ON wp_content.event_perfno_i = wo_header.event_perfno_i
        LEFT JOIN wo_header_more ON wp_content.event_perfno_i = wo_header_more.event_perfno_i
        JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
        JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
        LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
        LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
        LEFT JOIN maint_event_ext_reason ON wp_content.reason = maint_event_ext_reason.reason
    WHERE
        wp_content.wpno_i IN  (@VAR.WP@)
        AND        wo_header.state IN ('C','O')
AND NOT (wo_header.type = 'PD' AND wo_header.event_type = 'Q')
AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
    GROUP BY
        wp_content.event_perfno_i,
        wp_content.wpno_i,
        event_template.wtno_i,
        work_template.template_number,
        wp_header.station,
        wp_header.ac_registr,
        wo_header.event_type,
        wo_header.state,
        wp_header.start_date,
        wp_header.start_time,
        wp_header.end_date,
        wp_header.end_time,
        wo_header.prio,
        wo_text_description.header,
        wo_text_description.text,
        wo_text_description.text_html,
        wp_content.remarks,
        maint_event_ext_reason.description,
        wp_content.created_by,
        work_template.template_title
) AS combined_subquery
) AS filtered_data
WHERE row_num = 1
ORDER BY
    CASE
        WHEN "STATION" = 'SGN' THEN 1
        WHEN "STATION" = 'HAN' THEN 2
        WHEN "STATION" = 'DAD' THEN 3
        WHEN "STATION" = 'CXR' THEN 4
        WHEN "STATION" = 'HPH' THEN 5
        WHEN "STATION" = 'VCA' THEN 6
        WHEN "STATION" = 'PQC' THEN 7
        ELSE 8
    END,
    "AC_REG",
    "ITEM"