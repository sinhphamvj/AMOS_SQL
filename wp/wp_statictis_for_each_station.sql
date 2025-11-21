SELECT 
    wp_header.station AS "STATION",
    
    -- Tính tổng TOTAL_TASK dựa trên CLOSED_TOTAL và DEFERRED
   (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) +
     MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END)-
     MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) AS "TOTAL_TASK",
    
    -- Tổng số nhiệm vụ ASSIGNED
    (MAX(CASE WHEN task_counts."TASK_TYPE" = 'ASSIGNED' THEN task_counts."TASK_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)+
    MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END)) AS "ASSIGNED_TASK_TOTAL",
    
    -- Tổng số nhiệm vụ DEFERRED
    MAX(CASE WHEN task_counts."TASK_TYPE" = 'DEFERRED' THEN task_counts."TASK_COUNT" ELSE 0 END) AS "DEFERRED_TOTAL",


    -- Tỉ lệ DEFERRED_TOTAL so với TOTAL_TASK
    CASE 
        WHEN (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) +
              MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END)-
              MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) = 0 THEN 0
        ELSE
            ROUND(
                (
                    (MAX(CASE WHEN task_counts."TASK_TYPE" = 'DEFERRED' THEN task_counts."TASK_COUNT" ELSE 0 END)) * 100.0
                ) / 
                NULLIF(
                    (
                        MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) +
                        MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END) -
                        MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)
                    ), 0
                )
            , 1)
    END AS "DEFERRED_PERCENTAGE",
    
    -- Tổng số nhiệm vụ CLOSED
    (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) AS "CLOSED_TOTAL",

    -- Tỉ lệ CLOSED_TOTAL so với TOTAL_TASK
    CASE 
        WHEN (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) +
              MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END)-
              MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) = 0 THEN 0
        ELSE
            ROUND(
                (
                    (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) - MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) * 100.0
                ) / 
                NULLIF(
                    (
                        MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) +
                        MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END) -
                        MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)
                    ), 0
                )
            , 1)
    END AS "CLOSED_PERCENTAGE",
    
    --Tổng số initial task
    (MAX(CASE WHEN "TASK_TYPE" = 'ASSIGNED' THEN "TASK_COUNT" ELSE 0 END) +
    MAX(CASE WHEN "TASK_TYPE" = 'TASK_DEASIGN' THEN "TASK_COUNT" ELSE 0 END)) AS "INITAL_TASK"
   
FROM wp_header

LEFT JOIN (
    -- Query cho ASSIGNED_TASK_TOTAL
    SELECT wp_header.station, COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'ASSIGNED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
    WHERE wp_assignment.wpno_i IN (@VAR.WP@)
    AND NOT (wo_header.type = 'PD' AND wo_header.event_type = 'Q')
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
    GROUP BY wp_header.station

    UNION ALL

    -- Query cho DEFERRED_TOTAL
    SELECT wp_header.station, COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'DEFERRED' AS "TASK_TYPE"
    FROM wp_content
    JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_content.event_perfno_i
    WHERE wp_content.wpno_i IN (@VAR.WP@)
    AND wp_content.event_status = 'N'
    AND wp_content.reason IS NOT NULL 
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
    GROUP BY wp_header.station

    UNION ALL

    -- Query cho CLOSED_TOTAL
    SELECT wp_header.station, COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'CLOSED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
    WHERE wp_assignment.wpno_i IN (@VAR.WP@)
    AND wo_header.state = 'C'
    AND NOT (wo_header.type = 'PD' AND wo_header.event_type = 'Q')
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
    GROUP BY wp_header.station

    UNION ALL
    -- Query cho TOTAL JC NOT PERFORMED
    SELECT wp_header.station, COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'JC_NOT_PERFORMED' AS "TASK_TYPE"
    FROM wp_content
    JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_content.event_perfno_i
    WHERE wp_content.wpno_i IN (@VAR.WP@)
    AND wo_header.state = 'C'AND wo_header.event_type = 'JC'
    AND (wo_header.projectno IS NULL OR wo_header.projectno != 'DAILY WP')
    AND wp_content.event_status = 'N'
    GROUP BY wp_header.station

    UNION ALL
    -- Query cho TOTAL WO NOT PERFORMED
    SELECT wp_header.station, COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'WO_NOT_PERFORMED' AS "TASK_TYPE"
    FROM wp_content
    JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = wp_content.event_perfno_i
    WHERE wp_content.wpno_i IN (@VAR.WP@)
    AND wo_header.event_type != 'JC'
    AND wp_content.event_status = 'N'
    GROUP BY wp_header.station

    UNION ALL
    -- Query cho TOTAL TASK DE-ASSIGN BY MOC
    SELECT wp_header.station, COUNT(wp_history.wpno_i) AS "TASK_COUNT", 'TASK_DEASIGN' AS "TASK_TYPE"
    FROM wp_history
    LEFT JOIN wp_header ON wp_header.wpno_i = wp_history.wpno_i
    WHERE
    wp_history.wpno_i IN (@VAR.WP@)
    AND wp_history.action_time <= (@VAR.TIME@)
   AND wp_history.action_type = 'D'
   GROUP BY wp_header.station

) AS task_counts
ON wp_header.station = task_counts.station

WHERE wp_header.station IN ('SGN', 'HAN', 'DAD', 'CXR', 'PQC', 'VCA', 'VII', 'HPH')
GROUP BY wp_header.station
ORDER BY 
    CASE
        WHEN wp_header.station = 'SGN' THEN 1
        WHEN wp_header.station = 'HAN' THEN 2
        WHEN wp_header.station = 'DAD' THEN 3
        WHEN wp_header.station = 'CXR' THEN 4
        WHEN wp_header.station = 'HPH' THEN 5
        WHEN wp_header.station = 'PQC' THEN 6
        WHEN wp_header.station = 'VCA' THEN 7
        WHEN wp_header.station = 'VII' THEN 8
        ELSE 9
    END