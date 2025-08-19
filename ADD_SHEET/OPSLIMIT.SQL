SELECT db_link.ref_type,
	db_link.description,
    wo_text_action.actionno_i
FROM  wo_text_action
LEFT JOIN db_link ON wo_text_action.actionno_i::VARCHAR = db_link.source_pk
WHERE 
wo_text_action.event_perfno_i :: VARCHAR = '@MCC Open MEL per Aircraft.wo_header.event_perfno_i@'
	AND db_link.source_type = 'WOA'
	AND db_link.ref_type IN ('MEL','AMM','CDL','SRM','NTM','TSM')
ORDER BY wo_text_action.actionno_i ASC
LIMIT 1

/*
SELECT db_link.ref_type,
	db_link.description,
	 wo_text_action.actionno_i
FROM  wo_header
LEFT join wo_text_action on wo_header.event_perfno_i = wo_text_action.event_perfno_i
LEFT JOIN db_link ON wo_text_action.actionno_i::VARCHAR = db_link.source_pk
WHERE 
wo_header.event_perfno_i = 10105915
	AND db_link.source_type = 'WOA'
	AND db_link.ref_type IN ('MEL')
    */