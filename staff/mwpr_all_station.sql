SELECT 
    dc.station AS "STATION",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'A') AS "A",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'B1') AS "B1",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'B2') AS "B2",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'MECH') AS "MECH",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'TRAINEE_MECH') AS "TRAINEE_MECH",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill IN ('A', 'B1', 'B2', 'MECH', 'TRAINEE_MECH')) AS "TOTAL"
FROM
    (
    SELECT
        d.day,
        s.station,
        s.user_sign,
        CASE
            WHEN spq.pqs_type_no_i = 1378 THEN 'A'
            WHEN spq.pqs_type_no_i = 1379 THEN 'B1'
            WHEN spq.pqs_type_no_i IN (1380, 2771) THEN 'B2'
            WHEN s.skill_shop = 'MECH' THEN 'MECH'
            WHEN s.skill_shop = 'TRAINEE_MECH' THEN 'TRAINEE_MECH'
        END AS skill
    FROM
        (SELECT TO_DATE('03.Nov.2025', 'DD.MON.YYYY') AS day) AS d
    LEFT JOIN (
        SELECT s.user_sign, s.employee_no_i, s.skill_shop, sua.start_date, sua.start_time, sua.entry_type, sua.end_time, sp_shift.location as station
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location IN ('SGN', 'HAN', 'DAD','CXR')
          AND (
              (
                    
                     entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E','OT_N','BD2','K2')
                        
                    
            )
          )
    ) s ON (DATE '1971-12-31' + s.start_date)::DATE = d.day
    LEFT JOIN staff_pqs_qualification spq ON s.employee_no_i = spq.employee_no_i
) dc
GROUP BY
    dc.day, dc.station
ORDER BY
    dc.station