SELECT 
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
       sign.auth_number AS auth_no
FROM wo_transfer         
LEFT JOIN sign ON wo_transfer.user_sign = sign.user_sign             
WHERE 
         wo_transfer.transfer_type = 'T'                                                                     
         AND wo_transfer.event_perfno_i::VARCHAR = COALESCE('@MCC Open MEL per Aircraft.wo_header.event_perfno_i@'::VARCHAR, 'Null')
       ORDER BY date_transfer LIMIT 1