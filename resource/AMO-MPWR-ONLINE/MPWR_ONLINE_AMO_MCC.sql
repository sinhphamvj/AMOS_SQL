SELECT
    ROW_NUMBER() OVER (ORDER BY
        CASE "VJC_ID"
            WHEN 'VJC6509' THEN 0
            WHEN 'VJC0557' THEN 0
            ELSE 1
        END,
        CASE shift_type
            WHEN 'M'  THEN 1
            WHEN 'N'  THEN 2
            WHEN 'HC' THEN 3
            WHEN 'FE' THEN 4
            ELSE 5
        END,
        CASE "VJC_ID"
            WHEN 'VJC6509' THEN 1
            WHEN 'VJC0557' THEN 2
            WHEN 'VJC13144' THEN 3
            WHEN 'VJC1987' THEN 4
            WHEN 'VJC12534' THEN 5
            WHEN 'VJC4676' THEN 6
            WHEN 'VJC6277' THEN 7
            WHEN 'VJC10830' THEN 8
            WHEN 'VJC9016' THEN 9
            WHEN 'VJC1690' THEN 10
            WHEN 'VJC8412' THEN 11
            WHEN 'VJC10957' THEN 12
            WHEN 'VJC9872'  THEN 13
            ELSE 14
        END
    ) AS "STT",
    employee_no_i AS "ID",
    "VJC_ID",
    firstname,
    start_date,
    start_time,
    end_time,
    shift_type
FROM (
    SELECT
        s.employee_no_i,
        s.user_sign AS "VJC_ID",
        s.firstname,
        sua.entry_type,
        sua.shift_id,
        TO_CHAR(CAST(DATE '1971-12-31' + sua.start_date AS DATE), 'DD.MON.YYYY') AS start_date,
        sua.start_time,
        sua.end_time,
        CASE
            WHEN sua.entry_type IN ('B12_O','B21_O')
                AND (sua.start_time >= 1380 OR sua.start_time <= 660) THEN 'M'
            WHEN sua.entry_type IN ('B13_O','B22_O','B21_M')
                AND sua.end_time >= 660 AND sua.end_time <= 1380 THEN 'N'
            WHEN sua.entry_type LIKE 'HC%' THEN 'HC'
            WHEN sua.entry_type IN ('B21_O')
                AND (sua.start_time >= 1410 OR sua.start_time <= 690) THEN 'M'
            WHEN sua.entry_type IN ('B22_O')
                AND sua.end_time >= 690 AND sua.end_time <= 1410 THEN 'N'
            WHEN sua.entry_type LIKE '%FE%' THEN 'FE'
            WHEN sua.entry_type IN ('OT_M') THEN 'OT_M'
            WHEN sua.entry_type IN ('OT_N') THEN 'OT_N'
            WHEN sua.entry_type IN ('OT','OT_O') THEN
                CASE
                    WHEN sua.end_time <= 690  THEN 'OT_M'
                    WHEN sua.end_time <= 1410 THEN 'OT_N'
                    ELSE NULL
                END
            ELSE NULL
        END AS shift_type
    FROM sign s
    JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
    WHERE s.department = 'VJC AMO'
        AND s.status = 0
        AND sp_shift.location = 'SGN'
        AND sua.status <> 9
        AND sua.shift_id IN ('AMO_MCC_HC','AMO_MCC_MN')
        AND sua.entry_type NOT LIKE '%AL%'
        AND sua.entry_type NOT LIKE '%DO%'
        AND sua.entry_type NOT LIKE 'T'
        AND (
            (
                (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
                AND sua.start_time < 1380
            )
            OR (
                (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1
                AND sua.start_time >= 1380
            )
        )
) sub
ORDER BY
    CASE "VJC_ID"
        WHEN 'VJC6509' THEN 0
        WHEN 'VJC0557' THEN 0
        ELSE 1
    END,
    CASE shift_type
        WHEN 'M'  THEN 1
        WHEN 'N'  THEN 2
        WHEN 'HC' THEN 3
        WHEN 'FE' THEN 4
        ELSE 5
    END,
    CASE "VJC_ID"
        WHEN 'VJC6509' THEN 1
        WHEN 'VJC0557' THEN 2
        WHEN 'VJC13144' THEN 3
        WHEN 'VJC1987' THEN 4
        WHEN 'VJC12534' THEN 5
        WHEN 'VJC4676' THEN 6
        WHEN 'VJC6277' THEN 7
        WHEN 'VJC10830' THEN 8
        WHEN 'VJC9016' THEN 9
        WHEN 'VJC1690' THEN 10
        WHEN 'VJC8412' THEN 11
        WHEN 'VJC10957' THEN 12
        WHEN 'VJC9872'  THEN 13
        ELSE 14
    END