SELECT 
event_template.template_revisionno_i,
wo_header.ac_registr AS "AC_REG",
TRIM(SPLIT_PART(db_link.link_remarks, '/DUE:', 1)) AS "DESCRIPTION",
TRIM(SPLIT_PART(db_link.link_remarks, '/DUE:', 2)) AS "LIMITATION",
db_link.destination_key AS "WO",
doc_ref_data.ref_type AS "DOC_REF_TYPE",
doc_ref_data.description AS "DOC_REF",
wo_header.ata_chapter AS "ATA",
TO_CHAR(DATE '1971-12-31' + wo_header.issue_date, 'DD.MON.YYYY') AS "ISSUE_DATE",
TO_CHAR(DATE '1971-12-31' + wo_header.closing_date, 'DD.MON.YYYY') AS "TRANSFER_DATE"
FROM 
event_template
LEFT JOIN db_link ON event_template.event_perfno_i::VARCHAR = db_link.source_pk
LEFT JOIN wo_header ON db_link.destination_key = wo_header.event_perfno_i::VARCHAR
LEFT JOIN LATERAL (
    SELECT 
        db_link.description,
        db_link.ref_type
    FROM  wo_text_action
    LEFT JOIN db_link ON wo_text_action.actionno_i::VARCHAR = db_link.source_pk
    WHERE 
        wo_text_action.event_perfno_i = wo_header.event_perfno_i
        AND db_link.source_type = 'WOA'
        AND db_link.ref_type IN ('MEL','AMM','CDL','SRM','NTM','TSM')
    ORDER BY wo_text_action.actionno_i ASC
    LIMIT 1
) doc_ref_data ON true
WHERE
event_template.template_revisionno_i = 606097