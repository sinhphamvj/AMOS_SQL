SELECT
    COUNT(wp_header.wpno_i) AS "TOTALWP",
    SUM(CASE WHEN wp_header.wp_status = -2 THEN 1 ELSE 0 END) AS "TOTALWP_CLOSED",
    SUM(CASE WHEN wp_header.wp_status = -1 THEN 1 ELSE 0 END) AS "TOTALWP_OPENED"
FROM
    wp_header
WHERE
    wp_header.wpno_i IN (@VAR.WP@)