SELECT leg_additional.off_block_date,
       ac_utilization.departure_date,
       ac_utilization.validity,
       leg_additional.on_block_date,
       ac_utilization.ac_registr,
       aircraft.ac_typ,
       aircraft.operator,
       ac_utilization.leg_number,
       ac_utilization.fn_suffix,
       ac_utilization.service_type,
       fl2_header.flightlog_no_prefix,
       fl2_header.flightlog_no,
       ac_utilization.recno,
       ac_utilization.daily_hours,
       ac_utilization.daily_cycles,
       leg_additional.block_hours,
       ac_utilization.tah,
       ac_utilization.tac,
       ac_utilization.departure,
       ac_utilization.arrival,
       leg_additional.off_block_time,
       ac_utilization.departure_time,
       ac_utilization.arrival_time,
       leg_additional.on_block_time,
       ac_utilization.status,
       ac_utilization.null_leg_commited,
       ac_utilization.legno_i,
       fl2_header.flightlogno_i,
       leg_additional.remarks
FROM ac_utilization
LEFT JOIN fl2_leg ON ac_utilization.legno_i = fl2_leg.legno_i
LEFT JOIN fl2_header ON fl2_leg.flightlogno_i = fl2_header.flightlogno_i
LEFT JOIN leg_additional ON leg_additional.legno_i = ac_utilization.legno_i,
          aircraft
WHERE ac_utilization.ac_registr = aircraft.ac_registr
      AND aircraft.ac_registr = 'A525'
      AND (ac_utilization.validity BETWEEN 19532 AND 19542)
ORDER BY ac_utilization.ac_registr,
         ac_utilization.validity,
         ac_utilization.recno NULLS FIRST  
