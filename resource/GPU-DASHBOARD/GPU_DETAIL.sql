SELECT
    wp_header.wpno_i,
    wp_header.ac_registr,
    wp_header.wpno,
    wp_header.station,
    TO_CHAR(DATE '1971-12-31' + wp_header.start_date, 'DD.Mon.YYYY') AS "start_date",
    TO_CHAR(DATE '1971-12-31' + wp_header.end_date,'DD.Mon.YYYY') AS "end_date",
    wp_header.start_time,
    wp_header.end_time,
    CASE
        WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
        ELSE wp_header.end_time - wp_header.start_time
    END AS "maint_time",
    -- Rotables info
    rotables.partno,
    rotables.serialno,
    -- Thời gian chi tiết từ time_captured
    TO_CHAR(DATE '1971-12-31' + time_captured.start_date, 'DD.Mon.YYYY') AS captured_start_date,
    TO_CHAR(TRUNC(time_captured.start_time / 60), 'FM00') || ':' ||
    TO_CHAR(MOD(time_captured.start_time, 60), 'FM00')                   AS captured_start_time,
    TO_CHAR(DATE '1971-12-31' + time_captured.end_date, 'DD.Mon.YYYY')   AS captured_end_date,
    TO_CHAR(TRUNC(time_captured.end_time / 60), 'FM00') || ':' ||
    TO_CHAR(MOD(time_captured.end_time, 60), 'FM00')                     AS captured_end_time,
    TO_CHAR(TRUNC(time_captured.duration / 60), 'FM00') || ':' ||
    TO_CHAR(MOD(time_captured.duration, 60), 'FM00')                     AS captured_duration
FROM
    wp_header
    LEFT JOIN time_captured_additional ON time_captured_additional.wpno_i = wp_header.wpno_i
     JOIN time_captured ON time_captured.bookingno_i = time_captured_additional.bookingno_i
                      AND time_captured.mime_type = 'JCA'
    LEFT JOIN rotables ON time_captured.psn = rotables.psn
WHERE
    (   wpno LIKE '%OWP-'  || TO_CHAR(TO_DATE('@VAR.CHECK_DATE@', 'DD.Mon.YYYY'), 'DDMMYY') || '%'
     OR wpno LIKE '%TXWP-' || TO_CHAR(TO_DATE('@VAR.CHECK_DATE@', 'DD.Mon.YYYY'), 'DDMMYY') || '%')
    AND rotables.partno IS NOT NULL
    AND wp_header.station = 'HAN'
