SELECT
wp_header.ac_registr AS "AC_REG",
wp_header.wpno AS "WP_NAME",
    wp_header.station AS "STATION",
    
    TO_CHAR(DATE '1971-12-31' + wp_header.start_date, 'DD.MON.YYYY') AS "START_DATE",
  (wp_header.start_time / 60.0) AS "START_TIME",
    TO_CHAR(DATE '1971-12-31' + wp_header.end_date, 'DD.MON.YYYY') AS "END_DATE",
    (wp_header.end_time / 60.0) AS "END_TIME",
    ((wp_header.end_date - wp_header.start_date) * 24) + ((wp_header.end_time - wp_header.start_time) / 60.0) AS "GROUND_TIME",
    wp_header.remarks AS "REMARKS"
FROM
    wp_header
WHERE
    wp_header.start_date >= (TO_DATE('01.JAN.2026', 'DD.MON.YYYY') - DATE '1971-12-31') AND 
    wp_header.end_date <= (TO_DATE('31.DEC.2026', 'DD.MON.YYYY') - DATE '1971-12-31')
AND wp_header.hidden = 'H'
ORDER BY 
wp_header.ac_registr
