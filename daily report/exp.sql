SELECT
    wpno_i,
    wpno,
    TO_CHAR(
        TO_DATE(SUBSTRING(wpno FROM '[0-9]{6}'), 'DDMMYY'),
        'DD.MM.YYYY'
    ) AS wpno_date,
    TO_CHAR(DATE '1971-12-31' + start_date, 'DD.MON.YYYY') AS "START_DATE",
    TO_CHAR(DATE '1971-12-31' + MIN(start_date) OVER (), 'DD.MON.YYYY') AS "FROM",
    TO_CHAR(DATE '1971-12-31' + MAX(start_date) OVER (), 'DD.MON.YYYY') AS "TO"
    
FROM
    wp_header
WHERE
    wp_header.wpno_i IN (@VAR.WP@)

ORDER BY
    CASE 
        WHEN @VAR.SORT@ = '1' THEN 
            CASE
                WHEN wp_header.station = 'SGN' THEN 1
                WHEN wp_header.station = 'HAN' THEN 2
                WHEN wp_header.station = 'DAD' THEN 3
                WHEN wp_header.station = 'CXR' THEN 4
                WHEN wp_header.station = 'HPH' THEN 5
                WHEN wp_header.station = 'VII' THEN 6
                WHEN wp_header.station = 'VCA' THEN 7
                WHEN wp_header.station = 'PQC' THEN 8
                ELSE 9
            END
        ELSE NULL
    END,
    wp_header.ac_registr