SELECT
   DISTINCT wo_header.ac_registr,
   wo_header.event_perfno_i AS WO,
   wo_header.release_station,
   wo_header.mech_sign,
   TO_CHAR(
      DATE '1971-12-31' + wo_header.closing_date,
      'DD MON YYYY'
   ) AS WO_closing_date,
   TO_CHAR(
      DATE '1971-12-31' + bohi_changes.changes_date,
      'DD MON YYYY'
   ) AS WO_actual_changes_date,
   wp_header.wpno,
   bohi_changes.changes_time,
   bohi_changes.action
FROM
   wo_header full
   join bohi_version on wo_header.event_perfno_i = bohi_version.primkey
full join bohi_changes on bohi_version.versionno_i = bohi_changes.versionno_i
   left join wp_assignment on wo_header.event_perfno_i = wp_assignment.event_perfno_i
   left join wp_header on wp_assignment.wpno_i = wp_header.wpno_i
WHERE
   wo_header.type = 'S'
   and wo_header.state = 'C'
   and wo_header.ac_registr != 'COMP'
   and bohi_changes.action like '%Set priority%'
   and (
      wp_header.wpno NOT LIKE '%VJC%'
      OR wp_header.wpno IS NULL
   )
