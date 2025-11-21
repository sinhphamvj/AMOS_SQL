SELECT
   wh.event_perfno_i AS "WO",
   wh.ac_registr AS "AC_REG",
   wh.issue_station AS "ISSUE_STATION",
   TO_CHAR(DATE '1971-12-31' + wh.issue_date, 'DD.MON.YYYY') AS "ISSUE_DATE",
   wh.release_station AS "RELEASE_STATION",
   TO_CHAR(DATE '1971-12-31' + wh.closing_date, 'DD.MON.YYYY') AS "CLOSING_DATE",
   wo_header_more.approval_number,
   wt.text
FROM
   wo_header as wh
   LEFT JOIN wo_text_action wt ON wh.event_perfno_i = wt.event_perfno_i
   LEFT JOIN wo_header_more ON wh.event_perfno_i = wo_header_more.event_perfno_i
WHERE
   wh.ac_registr LIKE 'A%'
   AND wh.type = 'M'
   AND wt.sign_performed = 'MAINT'
   AND wh.issue_sign = 'MAINT'
   AND wt.action_date > 19480