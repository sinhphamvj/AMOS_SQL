SELECT
   DISTINCT ON (wh.ac_registr) wh.ac_registr AS "AC_REG",
   wh.event_perfno_i AS "WO_SCHED",
   CONCAT(
      LEFT(wh.release_time, 2),
      ':',
      RIGHT(wh.release_time, 2)
   ) AS "CLOSING_TIME",
   TO_CHAR(
      DATE '1971-12-31' + wh.closing_date,
      'DD MON YYYY'
   ) AS "CLOSING_DATE",
   wtd.text AS "CHECK"
FROM
   wo_header as wh
   LEFT JOIN workstep_link ON wh.event_perfno_i = workstep_link.event_perfno_i
   LEFT JOIN wo_text_description wtd ON workstep_link.descno_i = wtd.descno_i
WHERE
   (wtd.header LIKE 'PERFORM CHECK: WEEKLY%' or wtd.header LIKE '10D CHECK')
    and wh.ac_registr != 'DUMMY'
    and wh.type = 'S'
    and wh.state = 'C'
    AND DATE '1971-12-31' + wh.closing_date >= (current_timestamp - INTERVAL '10 days')
ORDER BY
   wh.ac_registr,
   wh.event_perfno_i DESC