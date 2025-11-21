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
       
FROM wo_transfer         
WHERE 
         wo_transfer.transfer_type = 'T'                                                                     
         AND wo_transfer.event_perfno_i::VARCHAR = COALESCE('@MCC Open MEL per Aircraft.wo_header.event_perfno_i@'::VARCHAR, 'Null')
       ORDER BY date_transfer LIMIT 1
