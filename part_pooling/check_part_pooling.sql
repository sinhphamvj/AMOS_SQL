SELECT
   wo_part_on_off.event_perfno_i,
   od_header.orderno,
   TO_CHAR(
      DATE '1971-12-31' + wo_part_on_off.created_date,
      'DD MON YYYY'
   ) AS ch_date,
   wo_header.release_station,
   wo_part_on_off.status,
   wo_part_on_off.partno_off,
   wo_part_on_off.serialno_off,
   wo_part_on_off.batchno_off,
   wo_part_on_off.mutator,
   sign.firstname,
   sign.lastname
FROM
   wo_part_on_off
   LEFT JOIN wo_header ON wo_part_on_off.event_perfno_i = wo_header.event_perfno_i
   LEFT JOIN sign ON wo_part_on_off.mutator = sign.user_sign
    JOIN od_rec_detail ON wo_part_on_off.serialno_off = od_rec_detail.serialno
    JOIN od_header ON od_header.orderno = od_rec_detail.orderno
WHERE
(DATE '1971-12-31' + wo_part_on_off.created_date) :: date >= (current_timestamp - interval '30 day') :: date
and (DATE '1971-12-31' + wo_part_on_off.created_date) :: date < (current_timestamp) :: date
   and (
      wo_part_on_off.status = 0
   )
   and wo_part_on_off.partno_off is not null
   and od_header.order_type IN (`PR`,`PX`) 
      AND od_header.ext_state IN ( 'R','PR')
      AND od_rec_detail.status <> 9

ORDER BY
   ch_date,
   wo_part_on_off.event_perfno_i
