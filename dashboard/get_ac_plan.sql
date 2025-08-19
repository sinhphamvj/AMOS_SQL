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