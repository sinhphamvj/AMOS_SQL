SELECT 
    base.station AS "STATION",
    MAX(CASE WHEN task_counts."TYPE" = 'NOT_BOOKED' THEN task_counts."COUNT" ELSE 0 END) AS "NOT_BOOKED_COUNT"
FROM (
    SELECT 'SGN' AS station UNION ALL SELECT 'HAN' UNION ALL SELECT 'DAD' UNION ALL 
    SELECT 'CXR' UNION ALL SELECT 'PQC' UNION ALL SELECT 'VCA' UNION ALL 
    SELECT 'VII' UNION ALL SELECT 'HPH' UNION ALL SELECT 'VTE'
) AS base
LEFT JOIN (
    SELECT 
        sign.homebase AS station, 
        COUNT(*) AS "COUNT", 
        'NOT_BOOKED' AS "TYPE"
    FROM wo_part_on_off
    JOIN wo_header ON wo_part_on_off.event_perfno_i = wo_header.event_perfno_i
    LEFT JOIN wo_text_action ON wo_part_on_off.actionno_i = wo_text_action.actionno_i
    LEFT JOIN sign ON wo_text_action.sign_performed = sign.user_sign
    WHERE 
        (DATE '1971-12-31' + wo_part_on_off.created_date) :: DATE BETWEEN TO_DATE('@VAR.START_DATE@', 'DD.MON.YYYY') AND TO_DATE('@VAR.END_DATE@', 'DD.MON.YYYY')
        
        AND wo_part_on_off.status = 0
        AND wo_text_action.sign_performed NOT LIKE 'TVJ%'
        AND (EXISTS (
                 SELECT aircraft.ac_registr
                 FROM aircraft
                 WHERE wo_header.ac_registr = aircraft.ac_registr
                       AND aircraft.ac_registr LIKE 'A%'
                       AND aircraft.operator = 'VJC'
                       AND aircraft.non_managed = 'N'
        ) OR wo_header.ac_registr = 'COMP')
    GROUP BY sign.homebase
) AS task_counts ON base.station = task_counts.station
GROUP BY base.station
ORDER BY 
    CASE
        WHEN base.station = 'SGN' THEN 1
        WHEN base.station = 'HAN' THEN 2
        WHEN base.station = 'DAD' THEN 3
        WHEN base.station = 'CXR' THEN 4
        WHEN base.station = 'HPH' THEN 5
        WHEN base.station = 'PQC' THEN 6
        WHEN base.station = 'VCA' THEN 7
        WHEN base.station = 'VII' THEN 8
        WHEN base.station = 'VTE' THEN 9
        ELSE 10
    END;