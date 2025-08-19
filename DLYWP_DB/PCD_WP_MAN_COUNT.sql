SELECT 
    -- Tổng số nhiệm vụ Mandatory + PRI1 (ASSIGNED với prio = 'M')
    MAX(CASE WHEN "TASK_TYPE" = 'MANDATORY' THEN "TASK_COUNT" ELSE 0 END) AS "MANDATORY_TOTAL",
    
    -- Tổng số nhiệm vụ Deferred (DEFERRED với prio = 'M')
    MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END) AS "DEFERRED_TOTAL",
    
    -- Tổng số nhiệm vụ Closed (CLOSED với prio = 'M')
    (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) AS "CLOSED_TOTAL",
    
    -- Tổng số nhiệm vụ (Mandatory +PRI1 + Deferred)
    (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) +
     MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END)-
     MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) AS "TOTAL_TASK"
    
FROM (
    -- Query cho MANDATORY_TOTAL (ASSIGNED với prio = 'M'&'PRI1')
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'MANDATORY' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wo_header ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
    WHERE wp_assignment.wpno_i IN (@VAR.WP@)
    AND (wo_header.prio = 'M' OR wo_header.prio = 'PRI1')
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')

    UNION ALL
    
    -- Query cho DEFERRED_TOTAL (DEFERRED với prio = 'M')
    SELECT COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'DEFERRED' AS "TASK_TYPE"
    FROM wp_content
    JOIN wo_header ON wo_header.event_perfno_i = wp_content.event_perfno_i
    WHERE wp_content.wpno_i IN (@VAR.WP@)
    AND wp_content.event_status = 'N'
    AND (wo_header.prio = 'M' OR wo_header.prio = 'PRI1')
    AND wp_content.reason IS NOT NULL 
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')


    UNION ALL
    
    -- Query cho CLOSED_TOTAL (CLOSED với prio = 'M')
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'CLOSED' AS "TASK_TYPE"
    FROM wp_assignment

    JOIN wo_header ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
    WHERE wp_assignment.wpno_i IN (@VAR.WP@)
    AND (wo_header.prio = 'M' OR wo_header.prio = 'PRI1')
     AND wo_header.state = 'C'
    AND NOT (wo_header.type = 'PD' AND wo_header.event_type = 'Q')
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
      

     UNION ALL
    -- Query cho TOTAL JC NOT PERFORMED
    SELECT COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'JC_NOT_PERFORMED' AS "TASK_TYPE"
    FROM wp_content
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_content.event_perfno_i
    WHERE wp_content.wpno_i IN (@VAR.WP@)
    AND wo_header.state = 'C'AND wo_header.event_type = 'JC'
    AND (wo_header.prio = 'M' OR wo_header.prio = 'PRI1')
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
) AS task_counts