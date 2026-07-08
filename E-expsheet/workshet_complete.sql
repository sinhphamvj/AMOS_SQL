SELECT
    filtered_data.VJCID,
    filtered_data.CAT,
    sign.firstname,
    ROUND(100.0 * SUM(CASE WHEN filtered_data.state = 'C' THEN 1 ELSE 0 END) / COUNT(*), 2) AS completion_percentage
FROM (
    SELECT DISTINCT ON (wp_header.wpno, SUBSTRING(work_template.template_number, 1, 3))
        wp_header.wpno,
        SUBSTRING(wp_header.wpno FROM '^[^-]+-([^-]+)') AS VJCID,
        SUBSTRING(wp_header.wpno FROM '-([^-]+)-[^-]+$') AS CAT,
        wo_header.state
    FROM wp_header
        LEFT JOIN wp_assignment ON wp_header.wpno_i = wp_assignment.wpno_i
        LEFT JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
        LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
        LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
    WHERE
        wp_header.wpno LIKE '%CAAV-CAT%'
        AND wp_header.ac_registr = 'AMOT'
        AND wo_header.event_type = 'JC'
    ORDER BY 
        wp_header.wpno,
        SUBSTRING(work_template.template_number, 1, 3), 
        CASE WHEN wo_header.state = 'C' THEN 1 ELSE 2 END,
        wo_header.event_perfno_i DESC
) AS filtered_data
LEFT JOIN sign ON sign.user_sign = filtered_data.VJCID
GROUP BY filtered_data.wpno, filtered_data.VJCID, filtered_data.CAT, sign.firstname
ORDER BY completion_percentage DESC
LIMIT 12
