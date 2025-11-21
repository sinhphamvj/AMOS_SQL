SELECT 
	wo_text_action.event_perfno_i
FROM  wo_text_action

WHERE 
		wo_text_action.event_perfno_i::VARCHAR = '@MCC Open MEL per Aircraft.wo_header.event_perfno_i@'
		AND (wo_text_action.text LIKE '%OPERATIONS PROCEDURE%' OR (wo_text_action.text LIKE '%OPS PROC%'))
	
