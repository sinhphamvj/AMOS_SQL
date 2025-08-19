SELECT
   wo_header.ac_registr,
   wo_part_on_off.event_perfno_i,
   TO_CHAR(
      DATE '1971-12-31' + wo_part_on_off.created_date,
      'DD MON YYYY'
   ) AS ch_date,
   wo_header.release_station,
   wo_part_on_off.status,
   wo_part_on_off.partno,
   wo_part_on_off.mutator
FROM
   wo_part_on_off full
   JOIN wo_header ON wo_part_on_off.event_perfno_i = wo_header.event_perfno_i
WHERE
(DATE '1971-12-31' + wo_part_on_off.created_date) :: date >= (current_timestamp - interval '7 day') :: date
and (DATE '1971-12-31' + wo_part_on_off.created_date) :: date < (current_timestamp) :: date
   and (
      wo_part_on_off.status = 0
   )
   and wo_part_on_off.created_by not like 'TVJ%'
   and wo_header.release_station IN (
      'SGN',
      'HAN',
      'DAD',
      'CXR',
      'PQC',
      'VII',
      'VCA',
      'HPH'
   )