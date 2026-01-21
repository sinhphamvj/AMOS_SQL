SELECT 
    t.template_number AS "JOBCARD_NAME",
    t.template_title AS "JOBCARD_TITLE",
    wo.workorderno_display AS "WO_NUMBER",
    wo.state AS "WO_STATE",
    wo.ac_registr AS "WO_AC_REG",
    wo.closing_date AS "WO_CLOSING_DATE"
FROM 
    (
        SELECT
            wt.wtno_i,
            wt.template_title,
            wt.template_number,
            CAST(NULLIF(SPLIT_PART(wt.template_number, '-', 3), '') AS INTEGER) AS extracted_wono
        FROM
            work_template wt
        WHERE
            wt.status = 0
            AND wt.template_type = 'J'
            AND wt.template_number ~ '^JC-[^-]+-[0-9]+$'

    ) AS t
     JOIN wo_header wo ON t.extracted_wono = wo.event_perfno_i
        AND wo.state = 'C'
    LEFT JOIN workstep_link wl ON wo.event_perfno_i = wl.event_perfno_i
        AND wl.sequenceno = (
            SELECT MAX(sequenceno) 
            FROM workstep_link wl2 
            WHERE wl2.event_perfno_i = wo.event_perfno_i
        )
    LEFT JOIN wo_text_description wo_desc ON wl.descno_i = wo_desc.descno_i
    LEFT JOIN wo_header jc ON jc.template_revisionno_i = t.wtno_i
        AND jc.event_type = 'JC'
        AND jc.type = 'PD'
        AND jc.event_perfno_i > 0
        AND jc.workorderno_display IS NULL
WHERE
    (wo_desc.text IS NULL OR wo_desc.text NOT LIKE '%REPETITIVE INSPECTION%')
ORDER BY 
    wo.closing_date DESC;