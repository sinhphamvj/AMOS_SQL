SELECT 
time_captured.primkey as "WO",
time_captured.user_sign,
TO_CHAR(DATE '1971-12-31' + time_captured.start_date, 'DD.Mon.YYYY') AS "start_date",
time_captured.start_time,
TO_CHAR(DATE '1971-12-31' + time_captured.end_date, 'DD.Mon.YYYY') AS "end_date",
time_captured.end_time,
time_captured.duration as "used_MHR"
FROM time_captured
LEFT JOIN wo_text_action wta ON time_captured.primkey = wta.event_perfno_i
LEFT JOIN db_link sub_dl ON wta.actionno_i::VARCHAR = sub_dl.source_pk
    AND sub_dl.source_type = 'WOA'
WHERE time_captured.user_sign = 'VJC0787'
      AND time_captured.start_date >= 19725
      AND time_captured.start_date <= 19756  
