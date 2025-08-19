SELECT
   wh.ac_registr,
   wh.event_perfno_i,
   TO_CHAR(
      DATE '1971-12-31' + wh.closing_date,
      'DD MON YYYY'
   ) AS c_date,
   wh.release_station,
   TO_CHAR(
      (wh.release_time) :: time,
      'HH24:MI'
   ) AS closing_time,
   wo_text_action.text
FROM
    wo_header as wh
   LEFT JOIN wo_text_action ON wh.event_perfno_i = wo_text_action.event_perfno_i

WHERE
   wh.closing_date >= 17533
   and wh.state = 'C'
   and wh.ac_registr != 'COMP'
   and (wh.mech_sign = 'VJC1694' or wo_text_action.sign_performed = 'VJC1694')
and wh.type IN ('M','P')