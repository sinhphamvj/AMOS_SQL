SELECT
time_captured_additional.wpno_i,
rotables.partno,
rotables.serialno,
time_captured.duration,
time_captured.start_date,
time_captured.start_time,
time_captured.end_date,
time_captured.end_time
FROM time_captured
LEFT JOIN rotables ON time_captured.psn = rotables.psn
LEFT JOIN time_captured_additional ON time_captured_additional.bookingno_i  = time_captured.bookingno_i
WHERE 

time_captured.primkey = 8006723 -- event_perf_no_i of jocbard feedback
AND time_captured.mime_type = 'JCA'