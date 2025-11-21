SELECT
   DISTINCT wo_header.ac_registr,
   wo_header.event_perfno_i AS WO,
   wo_header.release_station,
   wo_header.mech_sign,
   sign.firstname,
   TO_CHAR(
      DATE '1971-12-31' + wo_header.closing_date,
      'DD MON YYYY'
   ) AS WO_closing_date,
   TO_CHAR(
      DATE '1971-12-31' + bohi_changes.changes_date,
      'DD MON YYYY'
   ) AS WO_actual_closing_date,
   wp_header.wpno,
   wo_header.release_time,
   bohi_changes.changes_time,
   bohi_changes.action,
   (
      bohi_changes.changes_date - wo_header.closing_date
   ) AS date_difference,
   (
      CAST(LEFT(wo_header.release_time, 2) AS INTEGER) * 60 + CAST(RIGHT(wo_header.release_time, 2) AS INTEGER)
   ) AS release_time_minutes,
   bohi_changes.changes_time AS changes_time_minutes,
   -- Re-calculate time difference in minutes, adjusting for multiple day differences
   CASE
      WHEN wo_header.closing_date < bohi_changes.changes_date THEN (
         bohi_changes.changes_time + 1440 * (
            bohi_changes.changes_date - wo_header.closing_date
         )
      ) - (
         CAST(LEFT(wo_header.release_time, 2) AS INTEGER) * 60 + CAST(RIGHT(wo_header.release_time, 2) AS INTEGER)
      )
      ELSE bohi_changes.changes_time - (
         CAST(LEFT(wo_header.release_time, 2) AS INTEGER) * 60 + CAST(RIGHT(wo_header.release_time, 2) AS INTEGER)
      )
   END AS time_difference_minutes
FROM
   wo_header full
   join bohi_version on wo_header.event_perfno_i = bohi_version.primkey full
   join bohi_changes on bohi_version.versionno_i = bohi_changes.versionno_i
   Left join sign on wo_header.mech_sign = sign.user_sign
   left join wp_assignment on wo_header.event_perfno_i = wp_assignment.event_perfno_i
   left join wp_header on wp_assignment.wpno_i = wp_header.wpno_i
WHERE
(DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '1 day') :: date
   and wo_header.type = 'S'
   and wo_header.state = 'C'
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
   and wo_header.ac_registr != 'COMP'
   and bohi_changes.action like '%anually closed%'
   and (
      wp_header.wpno NOT LIKE '%VJC%'
      OR wp_header.wpno IS NULL
   )