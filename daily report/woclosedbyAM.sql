SELECT
   COUNT(DISTINCT wo_header.event_perfno_i) AS AMOS_MOBILE -- Count distinct WO CLOSED BY AMOS MOBILE
FROM
   wo_header full
   JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
   JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
   LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
   LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
   LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
WHERE
   wo_header.closing_date = 19325
   AND wo_header.type = 'S'
   AND wo_header.state = 'C'
   AND wo_header.release_station IN (
      'SGN',
      'HAN',
      'DAD',
      'CXR',
      'PQC',
      'VII',
      'VCA',
      'HPH'
   )
   AND wo_header.ac_registr != 'COMP'
   AND bohi_changes.action LIKE 'Workorder manually closed from AMOSmobile'
   AND (
      wp_header.wpno NOT LIKE '%VJC%'
      OR wp_header.wpno IS NULL
   )
   AND wo_header.mech_sign NOT IN ('VJC1273','VJC13794')
   AND wo_header.mech_sign LIKE 'VJC%'
