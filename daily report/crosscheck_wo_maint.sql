SELECT
   wh.event_perfno_i AS "WO_MAINT",
   CONCAT(
      LEFT(wh.release_time, 2),
      ':',
      RIGHT(wh.release_time, 2)
   ) AS "CLOSING_TIME_MAINT",
   TO_CHAR(
      DATE '1971-12-31' + wh.closing_date,
      'DD MON YYYY'
   ) AS "CLOSING_DATE_MAINT",
   wtd.text AS "CHECK_MAINT"
FROM
   wo_header as wh
   LEFT JOIN workstep_link ON wh.event_perfno_i = workstep_link.event_perfno_i
   LEFT JOIN wo_text_description wtd ON workstep_link.descno_i = wtd.descno_i
   LEFT JOIN wo_header_more ON wh.event_perfno_i = wo_header_more.event_perfno_i
WHERE
wh.ac_registr = '@MOC_DAILYCHECK_TOGO.AC_REG@' AND
   (wtd.text LIKE '%WEEKLY%' OR wtd.text LIKE '%@MOC_DAILYCHECK_TOGO.WO_SCHED@%'OR  wtd.text LIKE '%10 DAY%' OR wtd.text LIKE '%10D CHECK%')
    and wh.ac_registr LIKE 'A%'
    and wh.type = 'M'
    and wh.state = 'C'
    and wh.event_perfno_i > 10000000
    and wo_header_more.wo_class is null
    and CHAR_LENGTH(wtd.text) <= 68
    AND wtd.text NOT LIKE '%UPLOAD%'
    AND wtd.text NOT LIKE '%UP LOAD%'
    AND DATE '1971-12-31' + wh.closing_date >= (current_timestamp - INTERVAL '30 days')
ORDER BY
   wh.event_perfno_i DESC
LIMIT 1