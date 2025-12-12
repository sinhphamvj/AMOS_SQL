SELECT     
       wo_header.event_perfno_i,
       wo_header.ext_workorderno,
       CASE wo_header.mel_code WHEN 'L' THEN 'N/A' ELSE wo_header.mel_code END AS mel_code2,
       wo_header_more.mel_chapter,
      COALESCE(wo_header_4.chk_ops_consequence,'N') AS tf_chk_ops_consequence,
       CASE wo_header.mel_code    WHEN 'L' THEN 'CDL'    WHEN 'A' THEN 'MEL'    WHEN 'B' THEN 'MEL'    WHEN 'C' THEN 'MEL'    WHEN 'D' THEN 'MEL'    ELSE ''    END as add_type,
       wo_text_description.text AS description -- Get latest description            
FROM wo_header              
LEFT JOIN wo_header_more ON wo_header.event_perfno_i = wo_header_more.event_perfno_i 
LEFT JOIN wo_header_4 ON wo_header.event_perfno_i = wo_header_4.event_perfno_i                               
LEFT JOIN workstep_link ON workstep_link.event_perfno_i = wo_header.event_perfno_i 
                       AND workstep_link.sequenceno = (SELECT MAX(sequenceno) FROM workstep_link wl WHERE wl.event_perfno_i = wo_header.event_perfno_i)
LEFT JOIN wo_text_description ON wo_text_description.descno_i = workstep_link.descno_i                
WHERE wo_header.ac_registr = '@ACReg@'                                                                              
      AND wo_header.state = 'O'  
      AND wo_header.type IN ('M','P','C')                                                                            
      AND wo_header_more.wo_class IN  (
         'A',
         'L',
         'T'                                                        
      )                                                         
      AND wo_text_description.text NOT LIKE '%REPETITIVE INSPECTION FOR%'                                                            
GROUP BY wo_header.event_perfno_i,
         wo_header.ext_workorderno,
         CASE wo_header.mel_code WHEN 'L' THEN 'N/A' ELSE wo_header.mel_code END,
         wo_header_more.mel_chapter,
         COALESCE(wo_header_4.chk_ops_consequence,'N'),
         CASE wo_header.mel_code    WHEN 'L' THEN 'CDL'    WHEN 'A' THEN 'MEL'    WHEN 'B' THEN 'MEL'    WHEN 'C' THEN 'MEL'    WHEN 'D' THEN 'MEL'    ELSE ''    END,
         wo_text_description.text
ORDER BY wo_header.issue_date,
         wo_header.event_perfno_i