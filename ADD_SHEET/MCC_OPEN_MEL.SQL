SELECT     
       wo_header.event_perfno_i,
       wo_header.issue_date,
       wo_header.ext_workorderno,
       wo_header.issue_station,
       forecast.expected_date,
       forecast.expected_time,
       forecast.date_planned,
       wo_header.hil,
       wo_header.mel_code,
       CASE wo_header.mel_code WHEN 'L' THEN 'N/A' ELSE wo_header.mel_code END AS mel_code2,
       wo_header_more.mel_chapter,
       wo_header.closing_date,
       wo_header.ata_chapter,
       wo_header_4.mel_sla,
       wo_header_4.mel_detailno_i,
       forecast.dimension,
       forecast.togo,
       forecast.absolute_due_at_ac,
       forecast.workorderno_display,
       wo_header_more.o_item,
      COALESCE(wo_header_4.chk_ops_consequence,'N') AS tf_chk_ops_consequence,
       wo_opus.flt_deck_info,
       wo_opus.cabin_info,
       wo_header_crx.briefing_card,
       wo_header_crx.feedback_req,
       wo_header_more.wo_class,
       wo_header_crx.aog_risk,
       wo_header.type,
       wo_header.ac_registr,
       CASE wo_header.mel_code    WHEN 'L' THEN 'CDL'    WHEN 'A' THEN 'MEL'    WHEN 'B' THEN 'MEL'    WHEN 'C' THEN 'MEL'    WHEN 'D' THEN 'MEL'    ELSE ''    END as add_type,
       MAX(wo_text_description.text) AS description,-- Get latest description       
       wo_transfer.transfer_station AS tf_stn,
       TO_CHAR(
    COALESCE(DATE '1971-12-31' + baseline_date, DATE '1971-12-31' + wo_transfer.date_transfer),
    'DD MON YYYY') AS tf_base_date,
    TO_CHAR(DATE '1971-12-31'+ wo_transfer.date_transfer,'DD MON YYYY') AS tf_date,
      sign.lastname AS name_last,
      sign.firstname AS name_first,
      sign.auth_number AS auth_no
FROM wo_header            
JOIN forecast ON wo_header.event_perfno_i = forecast.event_perfno_i              
LEFT JOIN wo_header_more ON wo_header.event_perfno_i = wo_header_more.event_perfno_i            
LEFT JOIN wo_header_4 ON wo_header.event_perfno_i = wo_header_4.event_perfno_i            
LEFT JOIN wo_opus ON wo_header.event_perfno_i = wo_opus.event_perfno_i            
LEFT JOIN wo_header_crx ON wo_header.event_perfno_i = wo_header_crx.event_perfno_i  
LEFT JOIN workstep_link ON workstep_link.event_perfno_i = wo_header.event_perfno_i
LEFT JOIN wo_text_description ON wo_text_description.descno_i = workstep_link.descno_i 
LEFT JOIN (
            SELECT 
                  event_perfno_i,
                  user_sign,
                  transfer_station,
                  baseline_date,
                  date_transfer
            FROM wo_transfer
            WHERE transfer_type = 'T'
            ORDER BY date_transfer LIMIT 1
         ) wo_transfer ON wo_header.event_perfno_i = wo_transfer.event_perfno_i
         
LEFT JOIN sign ON wo_transfer.user_sign = sign.user_sign            
WHERE wo_header.ac_registr = '@ACReg@'                                                                              
      AND wo_header.state = 'O'                                                                              
      AND (
         forecast.workorderno_display IS NOT NULL                                                                                                                   
         OR forecast.event_type = 'W'                                                                              
      )                                                                              
      AND (
         (wo_header_4.chk_ops_consequence = 'Y')                                                                                                                   
         OR (wo_header.hil = 'Y')                                                                                                                   
         OR (
            wo_header.mel_code IS NOT NULL                                                                                                                                                        
            AND wo_header.mel_code <> 'F'                                                                                                                   
         )                                                                              
      )                                                            
      AND wo_header_more.wo_class IN  (
         'A',
         'L',
         'T'                                                        
      )                                                         
      AND (
         forecast.event_display NOT LIKE forecast.workorderno_display||'%/REPETITIVE INSPECTION FOR %'                                                       
      )         
GROUP BY wo_header.event_perfno_i,
         wo_header.issue_date,
         wo_header.ext_workorderno,
         wo_header.issue_station,
         forecast.expected_date,
         forecast.expected_time,
         forecast.date_planned,
         wo_header.hil,
         wo_header.mel_code,
         CASE wo_header.mel_code WHEN 'L' THEN 'N/A' ELSE wo_header.mel_code END,
         wo_header_more.mel_chapter,
         wo_header.closing_date,
         wo_header.ata_chapter,
         wo_header_4.mel_sla,
         wo_header_4.mel_detailno_i,
         forecast.dimension,
         forecast.togo,
         forecast.absolute_due_at_ac,
         forecast.workorderno_display,
         wo_header_more.o_item,
         COALESCE(wo_header_4.chk_ops_consequence,'N'),
         wo_opus.flt_deck_info,
         wo_opus.cabin_info,
         wo_header_crx.briefing_card,
         wo_header_crx.feedback_req,
         wo_header_more.wo_class,
         wo_header_crx.aog_risk,
         wo_header.type,
         wo_header.ac_registr,
         wo_transfer.transfer_station,
         wo_transfer.baseline_date,
         wo_transfer.date_transfer,
         sign.lastname,
         sign.firstname,
         sign.auth_number,
         CASE wo_header.mel_code    WHEN 'L' THEN 'CDL'    WHEN 'A' THEN 'MEL'    WHEN 'B' THEN 'MEL'    WHEN 'C' THEN 'MEL'    WHEN 'D' THEN 'MEL'    ELSE ''    END
ORDER BY wo_header.issue_date,
         wo_header.event_perfno_i
