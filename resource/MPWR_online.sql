SELECT
    v.skill AS "SKILL",
    COUNT(DISTINCT
        CASE
            WHEN v.skill = 'A' AND spq.pqs_type_no_i = 1378 THEN s.user_sign
            WHEN v.skill = 'B1' AND spq.pqs_type_no_i = 1379 THEN s.user_sign
            WHEN v.skill = 'B2' AND spq.pqs_type_no_i IN (1380, 2771) THEN s.user_sign
            WHEN v.skill = 'MECH' AND s.skill_shop = 'MECH' THEN s.user_sign
            WHEN v.skill = 'TRAINEE' AND s.skill_shop = 'TRAINEE_MECH' THEN s.user_sign
            ELSE NULL
        END
    ) AS "TOTAL"
FROM
    (VALUES ('A', 1), ('B1', 2), ('B2', 3), ('MECH', 4), ('TRAINEE', 5)) AS v(skill, sort_order)
CROSS JOIN
    sign s
JOIN
    sp_user_availability sua ON s.user_sign = sua.user_sign
LEFT JOIN
    staff_pqs_qualification spq ON s.employee_no_i = spq.employee_no_i
WHERE
    s.department = 'VJC AMO'
    AND s.status = 0
AND s.homebase = 'SGN'
    AND (
        DATE '1971-12-31' + sua.start_date + CASE WHEN sua.start_time + 420 >= 1440 THEN 1 ELSE 0 END
    )::DATE = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
   AND (
        (
            ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
            AND (entry_type IN ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7')
                OR (entry_type = 'OT' AND end_time <= 720)
            )
        )OR (
            ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
            AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E')
                OR (entry_type = 'OT' AND end_time > 720)
            )
        )
    )
    
GROUP BY
    v.skill, v.sort_order
ORDER BY
    v.sort_order