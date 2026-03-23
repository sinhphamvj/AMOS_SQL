SELECT
    wp_header.ac_registr  AS "AC_REG",
    wp_header.wpno        AS "WP_NO",
    wp_header.wpno_i,
    wp_header.station     AS "STATION",
    (DATE '1971-12-31' + wp_header.start_date)::DATE                                          AS "START_DATE",
    TO_CHAR(TIME '00:00' + (wp_header.start_time || ' minutes')::INTERVAL, 'HH24:MI')         AS "START_TIME",
    (DATE '1971-12-31' + wp_header.end_date)::DATE                                            AS "END_DATE",
    TO_CHAR(TIME '00:00' + (wp_header.end_time   || ' minutes')::INTERVAL, 'HH24:MI')         AS "END_TIME",
    FLOOR(
        ((wp_header.end_date - wp_header.start_date) * 1440 + (wp_header.end_time - wp_header.start_time))
        / 60
    )::INTEGER::TEXT
    || ':' ||
    LPAD(
        (((wp_header.end_date - wp_header.start_date) * 1440 + (wp_header.end_time - wp_header.start_time)) % 60)::TEXT,
        2, '0'
    ) AS "GROUND_TIME"
FROM wp_header
WHERE
    wp_header.start_date IS NOT NULL
    AND wp_header.end_date   IS NOT NULL
    AND wp_header.start_time IS NOT NULL
    AND wp_header.end_time   IS NOT NULL
    AND wp_header.status <> 9
    AND (wp_header.end_date - wp_header.start_date) <= 1
    AND wp_header.start_date >= ((current_timestamp::date - interval '1 day')::date - '1971-12-31'::date)
    AND wp_header.start_date <= (current_timestamp::date - '1971-12-31'::date)
    AND NOT EXISTS (
        SELECT 1
        FROM wp_assignment
        JOIN wo_header           ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
        JOIN workstep_link       ON wo_header.event_perfno_i     = workstep_link.event_perfno_i
                                AND workstep_link.sequenceno     = 1
        JOIN wo_text_description ON workstep_link.descno_i       = wo_text_description.descno_i
        WHERE wp_assignment.wpno_i = wp_header.wpno_i
          AND wo_header.state IN ('O', 'C')
          AND wo_text_description.header = 'DAILY CHECK'
    )
    AND NOT EXISTS (
        SELECT 1
        FROM wp_content
        JOIN wo_header           ON wp_content.event_perfno_i    = wo_header.event_perfno_i
        JOIN workstep_link       ON wo_header.event_perfno_i     = workstep_link.event_perfno_i
                                AND workstep_link.sequenceno     = 1
        JOIN wo_text_description ON workstep_link.descno_i       = wo_text_description.descno_i
        WHERE wp_content.wpno_i = wp_header.wpno_i
          AND wo_header.state IN ('O', 'C')
          AND wo_text_description.header = 'DAILY CHECK'
    )
ORDER BY
    CASE wp_header.station
        WHEN 'SGN' THEN 1
        WHEN 'HAN' THEN 2
        WHEN 'DAD' THEN 3
        WHEN 'CXR' THEN 4
        WHEN 'HPH' THEN 5
        WHEN 'VII' THEN 6
        WHEN 'VCA' THEN 7
        WHEN 'PQC' THEN 8
        ELSE 9
    END,
    wp_header.ac_registr
