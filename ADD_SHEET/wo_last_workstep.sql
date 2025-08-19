SELECT workstep_link.event_perfno_i AS wo_no,
       MAX(wo_text_description.text) AS description -- Get latest description       
FROM workstep_link       
LEFT JOIN wo_text_description ON wo_text_description.descno_i = workstep_link.descno_i       
WHERE (
         workstep_link.event_perfno_i::VARCHAR = COALESCE('@MCC Open MEL per Aircraft.wo_header.event_perfno_i@'::VARCHAR, 'Null')       
      ) 
GROUP BY workstep_link.event_perfno_i