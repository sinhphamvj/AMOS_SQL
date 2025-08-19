SELECT
   wh.event_perfno_i AS "WO"
FROM
   wo_header as wh
   LEFT JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
   LEFT JOIN forecast_dimension AS fd ON wh.event_perfno_i = fd.event_perfno_i
   LEFT JOIN aircraft ON wh.ac_registr = aircraft.ac_registr
WHERE
   wh.ac_registr NOT IN (
      SELECT
         mdr.ac_registr
      FROM
         moc_daily_records mdr
      WHERE
         mdr.event_group IN ('DLYRP')
         AND mdr.closed <> 'Y'
         AND mdr.event_type IN (
            'C_CHK',
            'A_CHK',
            'O_CHK',
            'PK_MT',
            'ST_MT',
            'AOG'
         )
         AND (
            (mdr.occurance_date * 24 * 60) + mdr.occurance_time
         ) <= (
            ((CURRENT_DATE - DATE '1971-12-31') * 24 * 60) + (
               EXTRACT(
                  HOUR
                  FROM
                     CURRENT_TIME
               ) * 60 + EXTRACT(
                  MINUTE
                  FROM
                     CURRENT_TIME
               )
            )
         )
   )
   AND wh.state = 'O'
   AND wh.type = 'S'
   AND (
      (DATE '1971-12-31' + fd.expected_date) :: date < current_timestamp :: date
   )
   AND wh.type != 'PD'
   AND aircraft.non_managed = 'N'
   AND aircraft.is_mod_controlled = 'Y'
   AND aircraft.operator = 'VJC'
   AND aircraft.ac_typ IN ('A330F', 'A321FL', 'A320')