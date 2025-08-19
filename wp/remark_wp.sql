SELECT
    wp_header.station AS "STATION",
    wp_header.ac_registr AS "AC_REG",
    TO_CHAR(DATE '1971-12-31' + wp_header.start_date, 'DD.MON.YYYY') AS "START_DATE",
    CASE 
        WHEN (wp_header.start_time + 420) >= 1440 THEN 
            TO_CHAR(TIME '00:00' + ((wp_header.start_time + 420 - 1440) || ' minutes')::interval, 'HH24:MI') || '+'
        ELSE 
            TO_CHAR(TIME '00:00' + ((wp_header.start_time + 420) || ' minutes')::interval, 'HH24:MI')
    END AS "START_TIME",
    TO_CHAR(DATE '1971-12-31' + wp_header.end_date, 'DD.MON.YYYY') AS "END_DATE",
    CASE 
        WHEN (wp_header.end_time + 420) >= 1440 THEN 
            TO_CHAR(TIME '00:00' + ((wp_header.end_time + 420 - 1440) || ' minutes')::interval, 'HH24:MI') || '+'
        ELSE 
            TO_CHAR(TIME '00:00' + ((wp_header.end_time + 420) || ' minutes')::interval, 'HH24:MI')
    END AS "END_TIME",
    TO_CHAR(TIME '00:00' + (
        CASE 
            WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
            ELSE wp_header.end_time - wp_header.start_time
        END || ' minutes')::interval, 'HH24:MI') AS "GROUND_TIME",
    wp_header.wpno AS "WP_NAME",
    wp_header.remarks AS "HIGHLIGHT",
    wp_header.internal_remarks AS "CONVERSATION"
FROM
    wp_header
WHERE
    wp_header.wpno_i IN (@VAR.WP@)
    AND (
        wp_header.remarks IS NOT NULL 
        OR wp_header.internal_remarks IS NOT NULL
    )
ORDER BY
    CASE
        WHEN wp_header.station = 'SGN' THEN 1
        WHEN wp_header.station = 'HAN' THEN 2
        WHEN wp_header.station = 'DAD' THEN 3
        WHEN wp_header.station = 'CXR' THEN 4
        WHEN wp_header.station = 'HPH' THEN 5
        WHEN wp_header.station = 'VCA' THEN 6
        WHEN wp_header.station = 'PQC' THEN 7
        ELSE 8
    END,
    wp_header.ac_registr