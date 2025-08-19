SELECT 
    -- Tính tổng TOTAL_TASK dựa trên CLOSED_TOTAL + DEFERRED_TOTAL
   (MAX(CASE WHEN "TASK_TYPE" = 'ASSIGNED' THEN "TASK_COUNT" ELSE 0 END) -
     MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END)) AS "OPEN_TASK",
    
    -- Tổng số nhiệm vụ ASSIGNED
(MAX(CASE WHEN task_counts."TASK_TYPE" = 'ASSIGNED' THEN task_counts."TASK_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)+
    MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END)) AS "ASSIGNED_TASK_TOTAL",
    
    -- Tổng số nhiệm vụ DEFERRED
    MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END) AS "DEFERRED_TOTAL",
    
    -- Tổng số nhiệm vụ CLOSED
    (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) AS "CLOSED_TOTAL"
    
FROM (
    -- Query cho ASSIGNED_TASK_TOTAL
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'ASSIGNED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
    WHERE wp_header.ac_registr IN (
        SELECT ac_registr
        FROM moc_daily_records mdr
        WHERE mdr.event_type = 'AOG'
        AND mdr.closed <> 'Y'
    )
    AND NOT (wo_header.type = 'PD' AND wo_header.event_type = 'Q')
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
    AND  wp_header.projectno = 'AOG-2025'
    AND wp_header.wp_status = -1
    UNION ALL
    
    -- Query cho DEFERRED_TOTAL
    SELECT COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'DEFERRED' AS "TASK_TYPE"
    FROM wp_content
    JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_content.event_perfno_i
    WHERE 
    wp_header.ac_registr IN (
        SELECT ac_registr
        FROM moc_daily_records mdr
        WHERE mdr.event_type = 'AOG'
        AND mdr.closed <> 'Y'
    )
    AND wp_content.event_status = 'N'
    AND wp_content.reason IS NOT NULL 
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
    AND  wp_header.projectno = 'AOG-2025'
    AND wp_header.wp_status = -1
    UNION ALL
    
    -- Query cho CLOSED_TOTAL
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'CLOSED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
    WHERE wp_header.ac_registr IN (
        SELECT ac_registr
        FROM moc_daily_records mdr
        WHERE mdr.event_type = 'AOG'
        AND mdr.closed <> 'Y'
    )
    AND wo_header.state = 'C'
    AND NOT (wo_header.type = 'PD' AND wo_header.event_type = 'Q')
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
    AND  wp_header.projectno = 'AOG-2025'
    AND wp_header.wp_status = -1
    UNION ALL
    -- Query cho TOTAL JC NOT PERFORMED
    SELECT COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'JC_NOT_PERFORMED' AS "TASK_TYPE"
    FROM wp_content
    JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_content.event_perfno_i
    WHERE 
    wp_header.ac_registr IN (
        SELECT ac_registr
        FROM moc_daily_records mdr
        WHERE mdr.event_type = 'AOG'
        AND mdr.closed <> 'Y'
    )
    AND wo_header.state = 'C' AND wo_header.event_type = 'JC'
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
AND wp_content.event_status = 'N'
AND  wp_header.projectno = 'AOG-2025'
AND wp_header.wp_status = -1
) AS task_counts
