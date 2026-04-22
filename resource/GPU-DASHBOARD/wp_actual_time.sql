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
    wp_header.status,
    -- Rotables info (chỉ có giá trị khi là dòng GPU)
    MAX(rotables.partno)                                            AS partno,
    MAX(rotables.serialno)                                         AS serialno,
    -- GPU: dòng có rotables.partno / serialno không NULL
    TO_CHAR(DATE '1971-12-31' + MIN(CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN time_captured.start_date  END), 'DD.Mon.YYYY')   AS gpu_start_date,
    (MIN(CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN time_captured.start_date * 10000 + time_captured.start_time  END) % 10000) AS gpu_start_time,
    TO_CHAR(DATE '1971-12-31' + MAX(CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN time_captured.end_date    END), 'DD.Mon.YYYY')   AS gpu_end_date,
    (MAX(CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN time_captured.end_date * 10000 + time_captured.end_time    END) % 10000)   AS gpu_end_time,
    SUM(CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN time_captured.duration    END)                   AS gpu_duration,
    -- ACTUAL_WP: dòng KHÔNG có rotables.partno / serialno
    TO_CHAR(DATE '1971-12-31' + MIN(CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN time_captured.start_date  END), 'DD.Mon.YYYY')   AS actual_wp_start_date,
    (MIN(CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN time_captured.start_date * 10000 + time_captured.start_time  END) % 10000) AS actual_wp_start_time,
    TO_CHAR(DATE '1971-12-31' + MAX(CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN time_captured.end_date    END), 'DD.Mon.YYYY')   AS actual_wp_end_date,
    (MAX(CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN time_captured.end_date * 10000 + time_captured.end_time    END) % 10000)   AS actual_wp_end_time,
    SUM(CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN time_captured.duration    END)                   AS actual_wp_duration

FROM
    wp_header
    LEFT JOIN time_captured_additional ON time_captured_additional.wpno_i = wp_header.wpno_i
     JOIN time_captured ON time_captured.bookingno_i = time_captured_additional.bookingno_i
                      AND time_captured.mime_type = 'JCA'
    LEFT JOIN rotables ON time_captured.psn = rotables.psn
WHERE
    wpno IN ('A522-OWP-220426-REV00','A535-OWP-220426-REV00','A524-OWP-220426-REV00','A630-OWP-220426-REV00')
GROUP BY
    wp_header.wpno_i,
    wp_header.ac_registr,
    wp_header.wpno,
    wp_header.station,
    wp_header.start_date,
    wp_header.end_date,
    wp_header.start_time,
    wp_header.end_time,
    wp_header.status
