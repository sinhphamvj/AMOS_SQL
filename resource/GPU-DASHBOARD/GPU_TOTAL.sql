SELECT
    TO_CHAR(TRUNC(SUM(CASE WHEN rotables.partno = 'GA140V13-VJGS' THEN time_captured.duration ELSE 0 END) / 60), 'FM00') || ':' || 
    TO_CHAR(MOD(SUM(CASE WHEN rotables.partno = 'GA140V13-VJGS' THEN time_captured.duration ELSE 0 END), 60), 'FM00') AS VJGS_GPU,
    SUM(CASE WHEN rotables.partno = 'GA140V13-VJGS' THEN time_captured.duration ELSE 0 END) AS VJGS_GPU_MINUTES,
    TO_CHAR(TRUNC(SUM(CASE WHEN rotables.partno IN ('GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END) / 60), 'FM00') || ':' || 
    TO_CHAR(MOD(SUM(CASE WHEN rotables.partno IN ('GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END), 60), 'FM00') AS VJ_GPU,
    SUM(CASE WHEN rotables.partno IN ('GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END) AS VJ_GPU_MINUTES,
    TO_CHAR(TRUNC(SUM(CASE WHEN rotables.partno IN ('GA140V13-VJGS', 'GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END) / 60), 'FM00') || ':' || 
    TO_CHAR(MOD(SUM(CASE WHEN rotables.partno IN ('GA140V13-VJGS', 'GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END), 60), 'FM00') AS TOTAL,
    SUM(CASE WHEN rotables.partno IN ('GA140V13-VJGS', 'GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END) AS TOTAL_MINUTES
FROM
    wp_header
    LEFT JOIN time_captured_additional ON time_captured_additional.wpno_i = wp_header.wpno_i
    JOIN time_captured ON time_captured.bookingno_i = time_captured_additional.bookingno_i
                      AND time_captured.mime_type = 'JCA'
    LEFT JOIN rotables ON time_captured.psn = rotables.psn
WHERE
    (   wpno LIKE '%OWP-'  || TO_CHAR(TO_DATE('@VAR.CHECK_DATE@', 'DD.Mon.YYYY'), 'DDMMYY') || '%'
     OR wpno LIKE '%TXWP-' || TO_CHAR(TO_DATE('@VAR.CHECK_DATE@', 'DD.Mon.YYYY'), 'DDMMYY') || '%')
    AND wp_header.station = 'HAN'
