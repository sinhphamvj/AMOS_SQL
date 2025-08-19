SELECT 
       
TO_CHAR( (FLOOR(ac_utilization.arrival_time / 60)::int + 7) % 24, 'FM00') || ':' || TO_CHAR( ac_utilization.arrival_time::int % 60, 'FM00') AS "ATA_TIME",
TO_CHAR( DATE '1971-12-31' + ac_utilization.validity , 'DD.MON.YYYY') as "ATA_DATE"
FROM ac_utilization
WHERE 
ac_utilization.ac_registr = '@REQ_OMC.AC_REG@'
AND 
ac_utilization.sched_departure_date = @VAR.DATE@
AND ac_utilization.leg_number = '@REQ_OMC.FLIGHT_NO@'
