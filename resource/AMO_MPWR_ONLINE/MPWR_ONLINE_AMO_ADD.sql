SELECT
    ROW_NUMBER() OVER (ORDER BY
        CASE "VJC_ID"
            WHEN 'VJC1666' THEN 1
            WHEN 'VJC8289' THEN 2
            WHEN 'VJC0550' THEN 3
            WHEN 'VJC0762' THEN 4
            WHEN 'VJC2766' THEN 5
            WHEN 'VJC2758' THEN 6
            WHEN 'VJC1663' THEN 7
            WHEN 'VJC15673' THEN 8
            ELSE 9
        END
    ) AS "STT",
    employee_no_i AS "ID",
    "VJC_ID",
    lastname,
    firstname,
    jobcode,
    "WORK_GROUP",
    "STATION",
    start_date,
    CASE
        WHEN entry_type LIKE '%B23%'
            THEN 'M'
        WHEN entry_type LIKE '%B24%'
            THEN 'N'
        WHEN entry_type LIKE '%OT%'
            THEN 'OT'
        WHEN entry_type LIKE '%HC%'
        THEN 'HC'
    END AS shift_type
FROM (
    SELECT DISTINCT
        s.employee_no_i,
        s.user_sign AS "VJC_ID",
        s.lastname,
        s.firstname,
        s.jobcode,
        sua.entry_type,
        s.workgroup AS "WORK_GROUP",
        sp_shift.location AS "STATION",
        TO_CHAR(CAST(DATE '1971-12-31' + sua.start_date AS DATE), 'DD.MON.YYYY') AS start_date
    FROM sign s
    JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
    WHERE s.department = 'VJC AMO'
        AND s.status = 0
        AND sp_shift.location = 'SGN'
        AND sua.status <> 9
        AND sua.shift_id IN ('MOC_ADD')
        AND sua.entry_type NOT LIKE 'AL%'
        AND sua.entry_type NOT LIKE 'DO%'
        AND sua.entry_type NOT LIKE 'T'
        AND sua.entry_type NOT LIKE 'DT%'
        AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
) sub
