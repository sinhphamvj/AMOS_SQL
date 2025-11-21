SELECT
ROW_NUMBER() OVER (ORDER BY
    CASE s.skill_shop
        WHEN 'B1' THEN 1
        WHEN 'B2' THEN 2
        WHEN 'A' THEN 3
        WHEN 'MECH' THEN 4
        WHEN 'TRAINEE_MECH' THEN 5
        ELSE 6
    END) AS "SEQ",
s.employee_no_i AS "ID",
s.user_sign as "VJC_ID",
s.skill_shop as "SKILL",
sua.entry_type as "ENTRY_TYPE",
sp_shift.location as "STATION"
FROM
    sign s
JOIN
    sp_user_availability sua ON s.user_sign = sua.user_sign
LEFT JOIN
    staff_pqs_qualification spq ON s.employee_no_i = spq.employee_no_i 
LEFT JOIN 
    sp_shift ON sp_shift.shift_id = sua.shift_id
WHERE
    s.department = 'VJC AMO'
    AND s.status = 0
AND sp_shift.location = 'SGN'
AND (spq.ac_type = 'A320' OR s.skill_shop IN ('MECH', 'TRAINEE_MECH'))
AND spq.status <> 9
AND sp_shift.shift_group_no_i in (903,904,905,906,907,1110)
    AND (
        DATE '1971-12-31' + sua.start_date + CASE WHEN sua.start_time + 420 >= 1440 THEN 1 ELSE 0 END
    )::DATE = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
   AND (
        (
            ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
            AND (entry_type IN  ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7','OT_M')
            )
        )OR (
            ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
            AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E','OT_N')
            )
        )
    ) 
GROUP BY s.employee_no_i, s.user_sign,sua.entry_type,sp_shift.location
ORDER BY
    CASE s.skill_shop
        WHEN 'B1' THEN 1
        WHEN 'B2' THEN 2
        WHEN 'A' THEN 3
        WHEN 'MECH' THEN 4
        WHEN 'TRAINEE_MECH' THEN 5
        ELSE 6
    END