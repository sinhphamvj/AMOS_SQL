SELECT 
    ROW_NUMBER() OVER (
        ORDER BY
            wp_header.station,
            wp_header.ac_registr
    ) AS "ITEM",
    wp_content.event_perfno_i AS "WO",
    wp_content.wpno_i,
    event_template.wtno_i,
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
    CASE WHEN wp_content.remarks IS NULL OR wp_content.remarks = '' THEN 'NIL' ELSE wp_content.remarks END AS "REMARKS",
   filtered_maint_event_ext_reason.description AS "REASON",
    wp_content.created_by AS "CREATED_BY"
FROM wp_content
LEFT JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i
LEFT JOIN wo_header ON wp_content.event_perfno_i = wo_header.event_perfno_i
LEFT JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
LEFT JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
LEFT JOIN (
    SELECT
        reason,
        description,
        ROW_NUMBER() OVER (PARTITION BY reason ORDER BY description) as rn
    FROM maint_event_ext_reason
    WHERE type IN ('B', 'N')
) AS filtered_maint_event_ext_reason ON wp_content.reason = filtered_maint_event_ext_reason.reason AND filtered_maint_event_ext_reason.rn = 1
WHERE wp_content.wpno_i IN (@VAR.WP@)
AND wp_content.event_status = 'N'
AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
GROUP BY wp_content.event_perfno_i,
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
         filtered_maint_event_ext_reason.description,
         wp_content.created_by,
         work_template.template_title
ORDER BY 
         wp_header.station,
wp_header.ac_registr