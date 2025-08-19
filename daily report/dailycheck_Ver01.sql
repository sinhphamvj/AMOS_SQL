SELECT
   DISTINCT ON (wh.ac_registr) wh.ac_registr AS "AC_REG",
   wh.event_perfno_i AS "WO_DAILYCHECK",
   CONCAT(
      LEFT(wh.release_time, 2),
      ':',
      RIGHT(wh.release_time, 2)
   ) AS "DUE_TIME",
   TO_CHAR(
      DATE '1971-12-31' + wh.closing_date + 2,
      'DD MON YYYY'
   ) AS "DUE_DATE",
   wtd.text AS "CHECK",
   TO_CHAR(
      (
         EXTRACT(
            EPOCH
            FROM
               (
                  DATE '1971-12-31' + wh.closing_date + 2 + (
                     LEFT(wh.release_time, 2) :: int * INTERVAL '1 hour'
                  ) + (
                     RIGHT(wh.release_time, 2) :: int * INTERVAL '1 minute'
                  )
               )
         ) / 60 - EXTRACT(
            EPOCH
            FROM
               current_timestamp
         ) / 60
      ) * INTERVAL '1 minute',
      'HH24:MI'
   ) AS "TO_GO",
   FLOOR(
      (
         EXTRACT(
            EPOCH
            FROM
               (
                  DATE '1971-12-31' + wh.closing_date + 2 + (
                     LEFT(wh.release_time, 2) :: int * INTERVAL '1 hour'
                  ) + (
                     RIGHT(wh.release_time, 2) :: int * INTERVAL '1 minute'
                  )
               )
         ) / 60 - EXTRACT(
            EPOCH
            FROM
               current_timestamp
         ) / 60
      )
   ) AS "TOGO_MINs"
FROM
   wo_header as wh
   LEFT JOIN workstep_link ON wh.event_perfno_i = workstep_link.event_perfno_i
   LEFT JOIN wo_text_description wtd ON workstep_link.descno_i = wtd.descno_i
WHERE
   wtd.text LIKE 'DAILY CHECK'
   and wh.ac_registr != 'DUMMY'
   AND DATE '1971-12-31' + wh.closing_date >= (current_timestamp - INTERVAL '7 days')
ORDER BY
   wh.ac_registr,
   wh.event_perfno_i DESC