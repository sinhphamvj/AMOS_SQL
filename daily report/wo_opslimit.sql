SELECT
   wh.event_perfno_i AS "WO",
   wh.ac_registr AS "AC_REG",
   wt.actionno_i,
   wt.text
FROM
   wo_header as wh
   LEFT JOIN wo_text_action wt ON wh.event_perfno_i = wt.event_perfno_i
   LEFT JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
   LEFT JOIN wo_text_description wtd ON wl.descno_i = wtd.descno_i
WHERE
   wh.ac_registr LIKE 'A%'
   AND (
      wt.text LIKE '%MEL LIMITATIONS: OPS PROC  - OPERATIONS PROCEDURE, OPS LIMIT  - OPERATIONS LIMITATION%'
      OR wt.text LIKE '%MEL LIMITATIONS: OPS LIMIT  - OPERATIONS LIMITATION%'
   )
   AND wh.state = 'O'
   AND wh.type = 'M'