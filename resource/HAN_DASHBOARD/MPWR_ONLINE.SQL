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
    sp_day_entry_type ON sua.entry_type = sp_day_entry_type.type_id
LEFT JOIN
    staff_pqs_qualification spq ON s.employee_no_i = spq.employee_no_i
LEFT JOIN 
    sp_shift ON sp_shift.shift_id = sua.shift_id
WHERE
    s.department = 'VJC AMO'
    AND s.status = 0
AND sp_day_entry_type.maintenance_context = 'Y'
AND sp_shift.location = 'HAN'
AND spq.status <> 9
    AND (
        DATE '1971-12-31' + sua.start_date + CASE WHEN sua.start_time + 420 >= 1440 THEN 1 ELSE 0 END
    )::DATE = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
   AND (
        (
            ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
            AND (entry_type IN  ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7','BD1','OT_M','SBD1','OBD1','BD5_O')
                OR (entry_type = 'OT_O' AND start_time BETWEEN 0 AND 540)
            )
        )OR (
            ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
            AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E','OT_N','BD2','SBD2','OBD2')
                OR (entry_type = 'OT_O' AND start_time BETWEEN 540 AND 1440)
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