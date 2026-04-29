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
    rotables.partno                                                AS partno,
    rotables.serialno                                              AS serialno,
    -- GPU: dòng có rotables.partno / serialno không NULL
    CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN TO_CHAR(DATE '1971-12-31' + time_captured.start_date, 'DD.Mon.YYYY') END   AS gpu_start_date,
    CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN time_captured.start_time END                     AS gpu_start_time,
    CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN TO_CHAR(DATE '1971-12-31' + time_captured.end_date, 'DD.Mon.YYYY') END     AS gpu_end_date,
    CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN time_captured.end_time END                       AS gpu_end_time,
    CASE WHEN rotables.partno IS NOT NULL OR rotables.serialno IS NOT NULL
             THEN time_captured.duration END                       AS gpu_duration,
    -- ACTUAL_WP: dòng KHÔNG có rotables.partno / serialno
    CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN TO_CHAR(DATE '1971-12-31' + time_captured.start_date, 'DD.Mon.YYYY') END   AS actual_wp_start_date,
    CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN time_captured.start_time END                     AS actual_wp_start_time,
    CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN TO_CHAR(DATE '1971-12-31' + time_captured.end_date, 'DD.Mon.YYYY') END     AS actual_wp_end_date,
    CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN time_captured.end_time END                       AS actual_wp_end_time,
    CASE WHEN rotables.partno IS NULL AND rotables.serialno IS NULL
             THEN time_captured.duration END                       AS actual_wp_duration

FROM
    wp_header
    LEFT JOIN time_captured_additional ON time_captured_additional.wpno_i = wp_header.wpno_i
    LEFT JOIN time_captured ON time_captured.bookingno_i = time_captured_additional.bookingno_i AND time_captured.mime_type = 'JCA'
    LEFT JOIN time_captured_history ON time_captured_history.bookingno_i = time_captured.bookingno_i   
    LEFT JOIN rotables ON time_captured.psn = rotables.psn

    JOIN wo_header ON wo_header.event_perfno_i = time_captured_history.primkey
    JOIN event_template ON event_template.template_revisionno_i = wo_header.template_revisionno_i
    JOIN work_template ON work_template.wtno_i = event_template.wtno_i
                      AND work_template.wtno_i = 368233
WHERE
    (wpno LIKE '%OWP-' || TO_CHAR(CURRENT_DATE - 1, 'DDMMYY') || '%' OR wpno LIKE '%TXWP-' || TO_CHAR(CURRENT_DATE - 1, 'DDMMYY') || '%')
