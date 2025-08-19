SELECT 
    -- Tổng số nhiệm vụ Mandatory (ASSIGNED với prio = 'M')
    SUM(CASE WHEN "TASK_TYPE" = 'ASSIGNED' THEN "TASK_COUNT" ELSE 0 END) AS "ASSINGED_DAILY_TOTAL",
    
    -- Tổng số nhiệm vụ Deferred (DEFERRED với prio = 'M')
    SUM(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END) AS "DEFERRED_DAILY_TOTAL",
    
    -- Tổng số nhiệm vụ Closed (CLOSED với prio = 'M')
    SUM(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) AS "CLOSED_DAILY_TOTAL",
    
    -- Tổng số nhiệm vụ (Mandatory + Deferred)
    (SUM(CASE WHEN "TASK_TYPE" = 'ASSIGNED' THEN "TASK_COUNT" ELSE 0 END) +
     SUM(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END)) AS "TOTAL_DAILY_TASK"
    
FROM (
    -- Query cho ASSIGNED TOTAL
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'ASSIGNED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i 
    JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
    LEFT JOIN wo_header_more ON wp_assignment.event_perfno_i = wo_header_more.event_perfno_i
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
    JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i

    WHERE         
    wp_assignment.wpno_i IN (@VAR.WP@) 
    AND wo_header.state IN ('C','O')
 AND wo_text_description.header LIKE 'PERFORM CHECK: DAILY CHECK-A320/A321%'

    UNION ALL
    
    -- Query cho DEFERRED_CABIN_TOTAL 
    SELECT COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'DEFERRED' AS "TASK_TYPE"
    FROM wp_content
    JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i 
    JOIN wo_header ON wp_content.event_perfno_i = wo_header.event_perfno_i
    LEFT JOIN wo_header_more ON wp_content.event_perfno_i = wo_header_more.event_perfno_i
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
    JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i

    WHERE         
        wp_content.wpno_i IN (@VAR.WP@) 
        AND wo_header.state IN ('C','O')
        AND wp_content.event_status = 'N'
      AND wo_text_description.header LIKE 'PERFORM CHECK: DAILY CHECK-A320/A321%'

    UNION ALL
    
    -- Query cho CLOSED_CABIN TOTAL
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'CLOSED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i 
    JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
    LEFT JOIN wo_header_more ON wp_assignment.event_perfno_i = wo_header_more.event_perfno_i
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
    JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i

    WHERE         
    wp_assignment.wpno_i IN (@VAR.WP@) 
    AND wo_header.state ='C'
    AND wo_text_description.header LIKE 'PERFORM CHECK: DAILY CHECK-A320/A321%'
) AS task_counts