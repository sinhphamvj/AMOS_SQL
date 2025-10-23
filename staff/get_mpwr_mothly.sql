SELECT 
    TO_CHAR(dc.day, 'DD.MON.YYYY') AS "DATE",
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
        s.user_sign,
        CASE
            WHEN spq.pqs_type_no_i = 1378 THEN 'A'
            WHEN spq.pqs_type_no_i = 1379 THEN 'B1'
            WHEN spq.pqs_type_no_i IN (1380, 2771) THEN 'B2'
            WHEN s.skill_shop = 'MECH' THEN 'MECH'
            WHEN s.skill_shop = 'TRAINEE_MECH' THEN 'TRAINEE_MECH'
        END AS skill
    FROM
        generate_series(
            TO_DATE('@VAR.START_DATE@', 'DD.MON.YYYY'), 
            TO_DATE('@VAR.END_DATE@', 'DD.MON.YYYY'),
            '1 day'
        ) AS d(day)
    LEFT JOIN (
        SELECT s.user_sign, s.employee_no_i, s.skill_shop, sua.end_date, sua.start_time, sua.entry_type, sua.end_time
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN'
          AND (
             (
                    ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
                    AND (entry_type IN ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7')
                        OR (entry_type = 'OT' AND end_time <= 720)
                    )
            ) OR (
                    ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
                    AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E')
                        OR (entry_type = 'OT' AND end_time > 720)
                    )
            )
          )
    ) s ON (DATE '1971-12-31' + s.end_date)::DATE = d.day
    LEFT JOIN staff_pqs_qualification spq ON s.employee_no_i = spq.employee_no_i
) dc
GROUP BY
    dc.day
ORDER BY
    dc.day