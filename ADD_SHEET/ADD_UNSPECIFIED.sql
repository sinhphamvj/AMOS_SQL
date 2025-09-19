SELECT 
work_template.wtno_i,
wo_header.event_perfno_i,
wo_header.ata_chapter AS "ATA",
work_template.template_title AS "DESCRIPTION",
wo_text_description.text AS "ACTION_TAKEN",
wo_text_description.text_html AS "ACTION_TAKEN_HTML",
CASE WHEN db_link.ref_type = 'WO' THEN AS "WO",

db_link.description AS "REF_DESC",
work_template.template_number,
event_template.template_revisionno_i
FROM 
work_template
LEFT JOIN event_template ON  work_template.wtno_i = event_template.wtno_i AND event_template.revision_status = 1
LEFT JOIN wo_header ON wo_header.template_revisionno_i = event_template.template_revisionno_i
LEFT JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
LEFT JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
LEFT JOIN db_link ON wo_text_description.descno_i::VARCHAR = db_link.source_pk
WHERE
work_template.wtno_i IN (
    SELECT wtno_i 
    FROM event_template_link
    WHERE 
    event_template_link.template_revisionno_i = 605399
)
