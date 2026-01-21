SELECT
    t.wtno_i,
    t.template_title,
    t.template_number,
    t.extracted_wono
  
FROM
    (
        SELECT
            wtno_i,
            template_title,
            template_number,
            CAST(NULLIF(SPLIT_PART(template_number, '-', 3), '') AS INTEGER) AS extracted_wono
        FROM
            work_template
        WHERE
            status = 0
            AND template_type = 'J'
            AND template_number ~ '^JC-[^-]+-[0-9]+$'
    ) AS t
LEFT JOIN
    wo_header ON t.extracted_wono = wo_header.event_perfno_i
WHERE 
      wo_header.state = 'C'
