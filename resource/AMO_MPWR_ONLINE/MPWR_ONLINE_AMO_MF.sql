SELECT
    ROW_NUMBER() OVER (ORDER BY
        CASE "VJC_ID"
            WHEN 'VJC4695' THEN 1
            WHEN 'VJC2765' THEN 2
            WHEN 'VJC4683' THEN 3
            WHEN 'VJC11580' THEN 4
            WHEN 'VJC6287' THEN 5
            WHEN 'VJC8972' THEN 6
            WHEN 'VJC18841' THEN 7
            WHEN 'VJC18840' THEN 8
            ELSE 9
        END
    ) AS "STT",
    employee_no_i AS "ID",
    "VJC_ID",
    firstname,
    "WORK_GROUP",
    "STATION",
    start_date,
    CASE
        WHEN entry_type LIKE '%R3%'
            THEN 'O'
        WHEN entry_type LIKE '%HC%'
            THEN 'HC'
        WHEN entry_type LIKE '%B6%'
            THEN 'A'
        WHEN entry_type IN('OT','OT_O')
            THEN 'OT'
    END AS shift_type
FROM (
    SELECT DISTINCT
        s.employee_no_i,
        s.user_sign AS "VJC_ID",
        s.firstname,
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
        AND sua.shift_id IN ('MOC_MF')
        AND sua.entry_type NOT LIKE 'AL%'
        AND sua.entry_type NOT LIKE 'DO%'
        AND sua.entry_type NOT LIKE 'T'
        AND sua.entry_type NOT LIKE 'DT%'
        AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
) sub
