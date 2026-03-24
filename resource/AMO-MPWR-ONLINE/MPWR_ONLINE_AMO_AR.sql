SELECT
    ROW_NUMBER() OVER (ORDER BY
        CASE "VJC_ID"
            WHEN 'VJC4697' THEN 1
            WHEN 'VJC4680' THEN 2
            WHEN 'VJC18826' THEN 3
            ELSE 4
        END
    ) AS "STT",
    employee_no_i AS "ID",
    "VJC_ID",
    firstname,
    start_date,
    CASE
        WHEN entry_type LIKE '%HC%'
            THEN 'HC'
        WHEN entry_type LIKE 'OT%' THEN 'OT'
    END AS shift_type
FROM (
    SELECT DISTINCT
        s.employee_no_i,
        s.user_sign AS "VJC_ID",
        s.firstname,
        sua.entry_type,
        TO_CHAR(CAST(DATE '1971-12-31' + sua.start_date AS DATE), 'DD.MON.YYYY') AS start_date
    FROM sign s
    JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
    WHERE s.department = 'VJC AMO'
        AND s.status = 0
        AND sp_shift.location = 'SGN'
        AND sua.status <> 9
        AND sua.shift_id IN ('MOC_AR')
        AND sua.entry_type NOT LIKE 'AL%'
        AND sua.entry_type NOT LIKE 'DO%'
        AND sua.entry_type NOT LIKE 'T'
        AND sua.entry_type NOT LIKE 'DT%'
        AND sua.user_sign IN ('VJC4697','VJC4680','VJC18826')
        AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
) sub