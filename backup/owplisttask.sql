SELECT 
    ROW_NUMBER() OVER (
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
            "AC_REG"
    ) AS "ITEM",
    "WO",
    "wpno_i",
    "wtno_i",
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
    "ACTION_TAKEN_HTML",
    "OTHER_REQUIREMENTS",
    "TOTAL_HOURS",
    "QTY",
    "SCOPE_STAFF",
    "AOG",
    "STORAGE",
    "PARKING"
FROM (
    -- Subquery for wp_assignment
    SELECT
        DISTINCT ON (wp_assignment.event_perfno_i) 
       CASE WHEN wo_header.event_type != 'JC' THEN wp_assignment.event_perfno_i::text ELSE work_template.template_number END AS "WO",
        wp_assignment.wpno_i,
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
        wo_text_description.header AS "DESCRIPTION",
        wo_text_description.text AS "ACTION_TAKEN",
        wo_text_description.text_html AS "ACTION_TAKEN_HTML",
        wo_header_more.other AS "OTHER_REQUIREMENTS",
        rm_resource_requirement.total_hours AS "TOTAL_HOURS",
        rm_resource_requirement.resource_quantity AS "QTY",
        rm_resource_constraint.char_value AS "SCOPE_STAFF",
        MAX(CASE WHEN moc_daily_records.event_type = 'AOG' THEN 1 ELSE 0 END) AS "AOG",
        MAX(CASE WHEN moc_daily_records.event_type = 'ST_MT' THEN 1 ELSE 0 END) AS "STORAGE",
        MAX(CASE WHEN moc_daily_records.event_type = 'PK_MT' THEN 1 ELSE 0 END) AS "PARKING"
    FROM
        wp_assignment
        JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i 
        JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
        LEFT JOIN wo_header_more ON wp_assignment.event_perfno_i = wo_header_more.event_perfno_i
        JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
        JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
        LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
        LEFT JOIN rm_resource_request ON workstep_link.descno_i = rm_resource_request.request_owner_amos_key 
        LEFT JOIN rm_resource_requirement ON rm_resource_request.resource_request_noi = rm_resource_requirement.resource_request_noi
        LEFT JOIN rm_resource_constraint ON rm_resource_requirement.resource_requirement_noi = rm_resource_constraint.resource_requirement_noi
        LEFT JOIN rm_property_type ON rm_resource_constraint.property_type_no_i = rm_property_type.property_type_no_i
        LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
        LEFT JOIN moc_daily_records ON wp_header.ac_registr = moc_daily_records.ac_registr
            AND moc_daily_records.closed <> 'Y'
            AND moc_daily_records.event_type IN ('AOG','ST_MT','PK_MT')
    WHERE
        wp_assignment.wpno_i IN (@PCD_WP_MAIN.wpno_i@) AND        wo_header.state IN ('C','O')
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
        wo_header_more.other,
        rm_resource_requirement.total_hours,
        rm_resource_requirement.resource_quantity,
        rm_resource_constraint.char_value

    UNION
    
    -- Subquery for wp_content
    SELECT
        DISTINCT ON (wp_content.event_perfno_i) 
      CASE WHEN wo_header.event_type != 'JC' THEN wp_content.event_perfno_i::text ELSE work_template.template_number END AS "WO",
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
        wo_text_description.header AS "DESCRIPTION",
        wo_text_description.text AS "ACTION_TAKEN",
        wo_text_description.text_html AS "ACTION_TAKEN_HTML",
        wo_header_more.other AS "OTHER_REQUIREMENTS",
        rm_resource_requirement.total_hours AS "TOTAL_HOURS",
        rm_resource_requirement.resource_quantity AS "QTY",
        rm_resource_constraint.char_value AS "SCOPE_STAFF",
        MAX(CASE WHEN moc_daily_records.event_type = 'AOG' THEN 1 ELSE 0 END) AS "AOG",
        MAX(CASE WHEN moc_daily_records.event_type = 'ST_MT' THEN 1 ELSE 0 END) AS "STORAGE",
        MAX(CASE WHEN moc_daily_records.event_type = 'PK_MT' THEN 1 ELSE 0 END) AS "PARKING"
    FROM
        wp_content
        JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i 
        JOIN wo_header ON wp_content.event_perfno_i = wo_header.event_perfno_i
        LEFT JOIN wo_header_more ON wp_content.event_perfno_i = wo_header_more.event_perfno_i
        JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
        JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
        LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
        LEFT JOIN rm_resource_request ON workstep_link.descno_i = rm_resource_request.request_owner_amos_key 
        LEFT JOIN rm_resource_requirement ON rm_resource_request.resource_request_noi = rm_resource_requirement.resource_request_noi
        LEFT JOIN rm_resource_constraint ON rm_resource_requirement.resource_requirement_noi = rm_resource_constraint.resource_requirement_noi
        LEFT JOIN rm_property_type ON rm_resource_constraint.property_type_no_i = rm_property_type.property_type_no_i
        LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
        LEFT JOIN moc_daily_records ON wp_header.ac_registr = moc_daily_records.ac_registr
            AND moc_daily_records.closed <> 'Y'
            AND moc_daily_records.event_type IN ('AOG','ST_MT','PK_MT')
    WHERE
        wp_content.wpno_i IN  (@PCD_WP_MAIN.wpno_i@) AND        wo_header.state IN ('C','O') AND wo_header.event_type <> 'JC'
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
        wo_header_more.other,
        rm_resource_requirement.total_hours,
        rm_resource_requirement.resource_quantity,
        rm_resource_constraint.char_value
) AS combined_subquery
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
    "AC_REG"