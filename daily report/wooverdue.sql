SELECT
   wh.event_perfno_i AS "WO",
   wh.ac_registr AS "AC_REG",
   TO_CHAR(DATE '1971-12-31' + wh.issue_date, 'DD.MON.YYYY') AS "ISSUE_DATE",
   TO_CHAR(
      DATE '1971-12-31' + MIN(fd.expected_date),
      'DD.MON.YYYY'
   ) AS "DUE_DATE",
   MAX(
      CASE
         WHEN fd.dimension = 'D' THEN CAST(fd.togo / 1440 AS INT)
      END
   ) AS "D-TOGO",
   MAX(
      CASE
         WHEN fd.dimension = 'H' THEN CAST(fd.togo / 60 AS INT)
      END
   ) AS "H-TOGO",
   MAX(
      CASE
         WHEN fd.dimension = 'C' THEN CAST(fd.togo AS INT)
      END
   ) AS "C-TOGO",
   wh.issue_sign,
   sign.firstname,
   wtd.text
FROM
   wo_header as wh
   LEFT JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
   LEFT JOIN wo_text_description wtd ON wl.descno_i = wtd.descno_i
   LEFT JOIN forecast_dimension AS fd ON wh.event_perfno_i = fd.event_perfno_i
   LEFT JOIN sign ON wh.issue_sign = sign.user_sign
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
GROUP BY
   wh.event_perfno_i,
   wtd.text,
   sign.firstname