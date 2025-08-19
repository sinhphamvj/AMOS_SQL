SELECT
   wp_header.wpno AS "WP_NAME",
   wp_header.station AS "STATION",
   wp_header.ac_registr AS "AC_REG",
   TO_CHAR(
      DATE '1971-12-31' + wp_header.start_date,
      'DD.MON.YYYY'
   ) AS "START_DATE",
   TO_CHAR(
      TIME '00:00' + (wp_header.start_time || ' minutes') :: interval,
      'HH24:MI'
   ) AS "START_TIME",
   TO_CHAR(
      DATE '1971-12-31' + wp_header.end_date,
      'DD.MON.YYYY'
   ) AS "END_DATE",
   TO_CHAR(
      TIME '00:00' + (wp_header.end_time || ' minutes') :: interval,
      'HH24:MI'
   ) AS "END_TIME",
   TO_CHAR(
      TIME '00:00' + (
         CASE
            WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
            ELSE wp_header.end_time - wp_header.start_time
         END || ' minutes'
      ) :: interval,
      'HH24:MI'
   ) AS "GROUND_TIME",
   wp_history.event_name AS "DESCRIPTION",
   wp_history.remarks AS "REASON REMARKS",
   wp_history.user_sign AS "CREATED_BY",
   wp_history.action_reason AS "REASON",
   wp_history.event_perfno_i AS "WO",
   wo_header.prio AS "PRIO"
FROM
   wp_history
   LEFT JOIN wp_header ON wp_header.wpno_i = wp_history.wpno_i
   LEFT JOIN wo_header ON wp_history.event_perfno_i = wo_header.event_perfno_i
 
WHERE
  wp_history.wpno_i IN (69770)
   AND wp_history.action_reason IN ('MOC_H1','MOC_H2','MOC_H3')
   AND wp_history.action_type = 'D'
ORDER BY 
   wp_header.station,
   wp_header.ac_registr
