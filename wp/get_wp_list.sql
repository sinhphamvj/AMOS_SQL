SELECT
    wpno_i,
    ac_registr,
    wpno,
    station,
    TO_CHAR(DATE '1971-12-31' + start_date, 'DD.Mon.YYYY') AS "start_date",
    TO_CHAR(DATE '1971-12-31' + end_date,'DD.Mon.YYYY') AS "end_date",
    

    start_time,
    end_time,
CASE
                        WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
                        ELSE wp_header.end_time - wp_header.start_time
                     END AS "maint_time",
    wp_status

FROM
    wp_header 
WHERE
     EXISTS (
         SELECT 1 FROM generate_series(1, 7) d
         WHERE wp_header.wpno LIKE '%OWP-' || TO_CHAR(CURRENT_DATE - d, 'DDMMYY') || '%' 
            OR wp_header.wpno LIKE '%TXWP-' || TO_CHAR(CURRENT_DATE - d, 'DDMMYY') || '%'
     )
