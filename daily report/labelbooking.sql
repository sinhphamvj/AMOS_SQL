SELECT
wh.ac_registr,
wo_part_on_off.event_perfno_i,
   TO_CHAR(
      DATE '1971-12-31' + wo_part_on_off.created_date,
      'DD MON YYYY'
   ) AS ch_date,
   wh.release_station,
   wo_part_on_off.status,
   wo_part_on_off.partno,
   wo_part_on_off.serialno,
   wt.sign_performed
FROM
   wo_part_on_off full
   JOIN wo_header wh ON wo_part_on_off.event_perfno_i = wh.event_perfno_i
   LEFT JOIN wo_text_action wt ON wh.event_perfno_i = wt.event_perfno_i
WHERE
(DATE '1971-12-31' + wo_part_on_off.created_date) :: date >= (current_timestamp - interval '7 day') :: date
and (DATE '1971-12-31' + wo_part_on_off.created_date) :: date < (current_timestamp) :: date
   and (
      wo_part_on_off.status = 0
   )
   and wo_part_on_off.created_by not like 'TVJ%'
   and wh.release_station IN (
      'SGN',
      'HAN',
      'DAD',
      'CXR',
      'PQC',
      'VII',
      'VCA',
      'HPH'
   )
   AND (
      wt.text LIKE '%COMPONENT CHANGE:%'
   )
   and wh.type IN ('M','P')
   and wh.ac_registr like 'A%'