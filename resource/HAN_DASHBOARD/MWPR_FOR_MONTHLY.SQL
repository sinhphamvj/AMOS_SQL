SELECT 
   TO_CHAR(dc.day, 'DD.MON.YYYY') AS "DATE",
    -- count by skill B1 and aircraft type
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'B1_PW') AS "B1_PW",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'B1_CFM') AS "B1_CFM",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill IN ('B1_PW', 'B1_CFM')) AS "B1_ALL",

-- count by skill B2 and aircraft type
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'B2_PW') AS "B2_PW",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'B2_CFM') AS "B2_CFM",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill IN ('B2_PW', 'B2_CFM')) AS "B2_ALL",

    -- count by skill A and aircraft type
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'A_PW') AS "A_PW",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'A_CFM') AS "A_CFM",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill IN ('A_PW', 'A_CFM')) AS "A_ALL",

    --  other skills
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'MECH') AS "MECH",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'TRAINEE_MECH') AS "TRAINEE_MECH",
        -- count by skill 330
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'B1_330') AS "B1_330",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'B2_330') AS "B2_330",
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill = 'A_330') AS "A_330",
    -- total MPWR
    COUNT(DISTINCT dc.user_sign) FILTER (WHERE dc.skill IN ('B1_PW', 'B1_CFM','B1_330','B2_PW','B2_CFM','B2_330','A_PW','A_CFM','A_330', 'MECH', 'TRAINEE_MECH')) AS "TOTAL"
FROM
    (
    SELECT
        d.day,
        s.user_sign,
        CASE
           WHEN spq.pqs_type_no_i = 1378 AND spq.ac_type = 'A320' AND spq.ac_sub_type = '-271N' THEN 'A_PW'
            WHEN spq.pqs_type_no_i = 1378 AND spq.ac_type = 'A320' AND spq.ac_sub_type <> '-271N' THEN 'A_CFM'
            WHEN spq.pqs_type_no_i = 1378 AND spq.ac_type = 'A330' THEN 'A_330'

            WHEN spq.pqs_type_no_i = 1379 AND spq.ac_type = 'A320' AND spq.ac_sub_type = '-271N' THEN 'B1_PW'
            WHEN spq.pqs_type_no_i = 1379 AND spq.ac_type = 'A320' AND spq.ac_sub_type <> '-271N' THEN 'B1_CFM'
            WHEN spq.pqs_type_no_i = 1379 AND spq.ac_type = 'A330' THEN 'B1_330'

            WHEN spq.pqs_type_no_i IN (1380, 2771) AND spq.ac_type = 'A320' AND spq.ac_sub_type = '-271N' THEN 'B2_PW'
            WHEN spq.pqs_type_no_i IN (1380, 2771) AND spq.ac_type = 'A320' AND spq.ac_sub_type <> '-271N' THEN 'B2_CFM'
            WHEN spq.pqs_type_no_i IN (1380, 2771) AND spq.ac_type = 'A330' THEN 'B2_330'

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
        SELECT s.user_sign, s.employee_no_i, s.skill_shop, sua.start_date, sua.start_time, sua.entry_type, sua.end_time
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'HAN'
          AND (
             (
                    ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
                    AND (entry_type IN ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7','BD1','OT_M','SBD1','OBD1')
                        OR (entry_type = 'OT' AND end_time <= 720)
                    )
            ) OR (
                    ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
                    AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E','OT_N','BD2','SBD2','OBD2')
                        OR (entry_type = 'OT' AND end_time > 720)
                    )
            )
          )
    ) s ON (DATE '1971-12-31' + s.start_date)::DATE = d.day
    LEFT JOIN staff_pqs_qualification spq ON s.employee_no_i = spq.employee_no_i
) dc
GROUP BY
    dc.day
ORDER BY
    dc.day