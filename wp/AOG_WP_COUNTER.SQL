SELECT
    COUNT(wp_header.wpno_i) AS "TOTALAOGWP",
    SUM(CASE WHEN wp_header.wp_status = -2 THEN 1 ELSE 0 END) AS "TOTALAOGWP_CLOSED",
    SUM(CASE WHEN wp_header.wp_status = -1 THEN 1 ELSE 0 END) AS "TOTALAOGWP_OPENED"
FROM
    wp_header
WHERE
   wp_header.projectno = 'AOG-2025'