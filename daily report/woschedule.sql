SELECT
   wo_header.ac_registr,
   wo_header.event_perfno_i,
   wo_header.release_station,
   TO_CHAR(
      DATE '1971-12-31' + wo_header.closing_date,
      'DD MON YYYY'
   ) AS closing_date,
   TO_CHAR(
      DATE '1971-12-31' + bohi_changes.changes_date,
      'DD MON YYYY'
   ) AS changed_date,
   TO_CHAR(
      (wo_header.release_time) :: time,
      'HH24:MI'
   ) AS closing_time,
   TO_CHAR(
      (
         (bohi_changes.changes_time || ' minutes') :: interval
      ),
      'HH24:MI'
   ) AS changes_time,
   bohi_changes.action
FROM
   wo_header full
   join bohi_version on wo_header.event_perfno_i = bohi_version.primkey full
   join bohi_changes on bohi_version.versionno_i = bohi_changes.versionno_i
WHERE
   wo_header.closing_date = 19293
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
   /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
SELECT
   wo_header.ac_registr,
   wo_header.event_perfno_i,
   TO_CHAR(
      DATE '1971-12-31' + wo_header.closing_date,
      'DD MON YYYY'
   ) AS c_date,
   wo_header.release_station,
   TO_CHAR(
      (wo_header.release_time) :: time,
      'HH24:MI'
   ) AS closing_time
FROM
   wo_header
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
   /**************** VER03*************/
SELECT
   wo_header.ac_registr,
   wo_header.event_perfno_i,
   wo_header.release_station,
   TO_CHAR(
      DATE '1971-12-31' + wo_header.closing_date,
      'DD MON YYYY'
   ) AS closing_date,
   TO_CHAR(
      DATE '1971-12-31' + bohi_changes.changes_date,
      'DD MON YYYY'
   ) AS changed_date,
   TO_CHAR(
      (wo_header.release_time) :: time,
      'HH24:MI'
   ) AS closing_time,
   TO_CHAR(
      (
         (bohi_changes.changes_time || ' minutes') :: interval
      ),
      'HH24:MI'
   ) AS changes_time,
   bohi_changes.action
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