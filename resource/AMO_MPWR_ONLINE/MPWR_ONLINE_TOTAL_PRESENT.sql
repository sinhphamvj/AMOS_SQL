SELECT 
    total.total_staff,
    today_p.today_present,
    total.total_staff - today_p.today_present AS today_absent,
    yesterday_p.yesterday_present,
    total.total_staff - yesterday_p.yesterday_present AS yesterday_absent,
    ROUND(today_p.today_present * 100.0 / total.total_staff, 1) AS today_pct,
    ROUND(yesterday_p.yesterday_present * 100.0 / total.total_staff, 1) AS yesterday_pct,
    ROUND((today_p.today_present - yesterday_p.yesterday_present) * 100.0 / total.total_staff, 1) AS delta_pct,
    COALESCE(leave_cnt.total_al, 0) AS total_al,
    COALESCE(leave_cnt.total_do, 0) AS total_do,
    COALESCE(leave_cnt.total_t, 0) AS total_t,
    COALESCE(leave_cnt.total_ot, 0) AS total_ot
FROM (
    SELECT COUNT(DISTINCT spa.user_sign) AS total_staff
    FROM sp_shift_assign spa
    WHERE spa.shift_id IN (
        'MOC_DM','MOC_COOR','MOC_FME','MOC_FMSE',
        'AMO_MCC_HC','AMO_MCC_MN',
        'MOC_TRN','MOC_ADD','MOC_MF','MOC_AR',
        'AMO_ICT','AMO_ADFIN','AMO_TRN','AMO_ADFN'
    )
) total,
(
    SELECT COUNT(*) AS today_present
    FROM (
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO'
            AND s.status = 0
            AND sp_shift.location = 'SGN'
            AND sua.status <> 9
            AND sua.shift_id IN ('MOC_DM','MOC_COOR','MOC_FME','MOC_FMSE','MOC_AR')
            AND sua.shift_pattern <> 'MOC_AR_O'
            AND sua.entry_type NOT LIKE '%AL%'
            AND sua.entry_type NOT LIKE '%DO%'
            AND sua.entry_type NOT LIKE 'T'
            AND sua.user_sign NOT IN ('VJC18826')
            AND (
                ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') AND sua.start_time < 1380)
                OR ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1 AND sua.start_time >= 1380)
            )
        UNION
        SELECT DISTINCT s.user_sign
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
                ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') AND sua.start_time < 1380)
                OR ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1 AND sua.start_time >= 1380)
            )
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('MOC_ADD')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('MOC_MF')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('AMO_ICT')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('AMO_ADFIN')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('MOC_AR')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND sua.user_sign IN ('VJC4697','VJC4680','VJC18826')
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('AMO_TRN')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
    ) t
) today_p,
(
    SELECT COUNT(*) AS yesterday_present
    FROM (
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO'
            AND s.status = 0
            AND sp_shift.location = 'SGN'
            AND sua.status <> 9
            AND sua.shift_id IN ('MOC_DM','MOC_COOR','MOC_FME','MOC_FMSE','MOC_AR')
            AND sua.shift_pattern <> 'MOC_AR_O'
            AND sua.entry_type NOT LIKE '%AL%'
            AND sua.entry_type NOT LIKE '%DO%'
            AND sua.entry_type NOT LIKE 'T'
            AND sua.user_sign NOT IN ('VJC18826')
            AND (
                ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1 AND sua.start_time < 1380)
                OR ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 2 AND sua.start_time >= 1380)
            )
        UNION
        SELECT DISTINCT s.user_sign
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
                ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1 AND sua.start_time < 1380)
                OR ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 2 AND sua.start_time >= 1380)
            )
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('MOC_ADD')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('MOC_MF')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('AMO_ICT')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('AMO_ADFIN')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('MOC_AR')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND sua.user_sign IN ('VJC4697','VJC4680','VJC18826')
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1
        UNION
        SELECT DISTINCT s.user_sign
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('AMO_TRN')
            AND sua.entry_type NOT LIKE 'AL%' AND sua.entry_type NOT LIKE 'DO%' AND sua.entry_type NOT LIKE 'T' AND sua.entry_type NOT LIKE 'DT%'
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1
    ) y
) yesterday_p,
(
    SELECT
        COUNT(DISTINCT CASE WHEN entry_type LIKE 'AL%' THEN user_sign END) AS total_al,
        COUNT(DISTINCT CASE WHEN entry_type LIKE 'DO%' THEN user_sign END) AS total_do,
        COUNT(DISTINCT CASE WHEN entry_type = 'T' THEN user_sign END) AS total_t,
        COUNT(DISTINCT CASE WHEN entry_type LIKE 'OT%' THEN user_sign END) AS total_ot
    FROM (
        SELECT s.user_sign, sua.entry_type
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('MOC_DM','MOC_COOR','MOC_FME','MOC_FMSE','MOC_AR','AMO_MCC_HC','AMO_MCC_MN')
            AND (sua.entry_type LIKE 'AL%' OR sua.entry_type LIKE 'DO%' OR sua.entry_type = 'T' OR sua.entry_type LIKE 'OT%')
            AND (
                ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') AND sua.start_time < 1380)
                OR ((DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY') - 1 AND sua.start_time >= 1380)
            )
        UNION
        SELECT s.user_sign, sua.entry_type
        FROM sign s
        JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
        LEFT JOIN sp_shift ON sp_shift.shift_id = sua.shift_id
        WHERE s.department = 'VJC AMO' AND s.status = 0 AND sp_shift.location = 'SGN' AND sua.status <> 9
            AND sua.shift_id IN ('MOC_ADD','MOC_MF','AMO_ICT','AMO_ADFIN','AMO_TRN','AMO_ADFN')
            AND (sua.entry_type LIKE 'AL%' OR sua.entry_type LIKE 'DO%' OR sua.entry_type = 'T' OR sua.entry_type LIKE 'OT%')
            AND (DATE '1971-12-31' + sua.start_date) = TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
    ) combined
) leave_cnt