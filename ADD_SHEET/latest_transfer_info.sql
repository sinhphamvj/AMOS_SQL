SELECT event_perfno_i AS wo_no,
       transfer_station AS tf_stn,
TO_CHAR(
    COALESCE(DATE '1971-12-31' + baseline_date, DATE '1971-12-31' + date_transfer),
    'DD MON YYYY'
) AS tf_base_date,
       TO_CHAR(
          DATE '1971-12-31'+date_transfer,
          'DD MON YYYY'        
       ) AS tf_date,
       sign.lastname AS name_last,
       sign.firstname AS name_first,
       sign.auth_number AS auth_no,
       wo_transfer.absolute_due_date,
       wo_transfer.absolute_due_time,
       due_tah.due_TAH,
       due_tac.due_TAC,
       dl.link_remarks,
       wo_transfer.remarks,
       CASE         WHEN dl.link_remarks IS NOT NULL AND dl.link_remarks != '' THEN dl.link_remarks
WHEN dl.link_remarks IS NULL OR dl.link_remarks = '' THEN TO_CHAR(
          DATE '1971-12-31' + wo_transfer.absolute_due_date,
          'DD MON YYYY'                        
       )       END AS due_date      
FROM wo_transfer        
LEFT JOIN sign ON wo_transfer.user_sign = sign.user_sign       
LEFT JOIN (
             SELECT event_transferno_i,
                    wo_transfer_dimension.counterno_i,
                    CAST(
                       CAST(
                          (wo_transfer_dimension.due_at::INT)/60 AS INT                                                                                                
                       ) AS     VARCHAR                                                                                    
                    )||':'|| RIGHT(
                       TO_CHAR(
                          (wo_transfer_dimension.due_at || 'SECOND')::INTERVAL,
                          'HH24:MI:SS'                                                                                                
                       ),
                       2                                                                                    
                    ) AS due_TAH                                                            
             FROM wo_transfer_dimension                                                            
             LEFT JOIN counter ON wo_transfer_dimension.counterno_i = counter.counterno_i                                                            
             LEFT JOIN counter_template ON counter.counter_templateno_i = counter_template.counter_templateno_i                                                            
             LEFT JOIN counter_definition ON counter_template.counter_defno_i = counter_definition.counter_defno_i                                                            
             WHERE counter_definition.code = 'H'                                                
          ) due_tah ON due_tah.event_transferno_i=wo_transfer.event_transferno_i     
LEFT JOIN (
             SELECT event_transferno_i,
                    wo_transfer_dimension.counterno_i,
                    CAST(wo_transfer_dimension.due_at AS INT) AS due_TAC                                                            
             FROM wo_transfer_dimension                                                            
             LEFT JOIN counter ON wo_transfer_dimension.counterno_i = counter.counterno_i                                                            
             LEFT JOIN counter_template ON counter.counter_templateno_i = counter_template.counter_templateno_i                                                            
             LEFT JOIN counter_definition ON counter_template.counter_defno_i = counter_definition.counter_defno_i                                                            
             WHERE  counter_definition.code = 'C'                                                
          ) due_tac ON due_tac.event_transferno_i=wo_transfer.event_transferno_i     
LEFT JOIN ( -- Join with the db_link subquery to get link_remarks
    SELECT source_pk,
        MAX(CASE WHEN ref_type = 'ADD' THEN UPPER(link_remarks) END) AS link_remarks 
    FROM db_link
    WHERE source_pk::VARCHAR = COALESCE('@MCC Open MEL per Aircraft.wo_header.event_perfno_i@'::VARCHAR, 'Null')
        AND source_type = 'WO'
    GROUP BY source_pk
) dl ON wo_transfer.event_perfno_i::VARCHAR = dl.source_pk -- Joining on the wo_no (casted to VARCHAR) 
WHERE (
         wo_transfer.transfer_type = 'T'                                         
         AND wo_transfer.is_last_transfer = 'Y'                                                 
         AND wo_transfer.event_perfno_i::VARCHAR = COALESCE('@MCC Open MEL per Aircraft.wo_header.event_perfno_i@'::VARCHAR, 'Null')                         
      ) LIMIT 1