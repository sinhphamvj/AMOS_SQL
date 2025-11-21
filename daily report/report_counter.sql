SELECT
   wo_header.release_station,
   COUNT(wo_header.release_station) AS station_count
FROM
   wo_header full
   join bohi_version on wo_header.event_perfno_i = bohi_version.primkey full
   join bohi_changes on bohi_version.versionno_i = bohi_changes.versionno_i
WHERE
   wo_header.closing_date = 19291
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
GROUP BY
   wo_header.release_station