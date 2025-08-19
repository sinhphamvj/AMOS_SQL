SELECT
   ROUND(
      CAST(wo_closed_mb."AMOS_MOBILE" AS integer) * 100.0 / CAST(wo_total."TOTAL_WO_CLOSED" AS integer)
   ) AS "PERCENT_AMOS_MOBILE_1",
   ROUND(
      CAST(wo_closed_mb_2."AMOS_MOBILE" AS integer) * 100.0 / CAST(wo_total_2."TOTAL_WO_CLOSED" AS integer)
   ) AS "PERCENT_AMOS_MOBILE_2",
   ROUND(
      CAST(wo_closed_mb_3."AMOS_MOBILE" AS integer) * 100.0 / CAST(wo_total_3."TOTAL_WO_CLOSED" AS integer)
   ) AS "PERCENT_AMOS_MOBILE_3",
   ROUND(
      CAST(wo_closed_mb_4."AMOS_MOBILE" AS integer) * 100.0 / CAST(wo_total_4."TOTAL_WO_CLOSED" AS integer)
   ) AS "PERCENT_AMOS_MOBILE_4",
   ROUND(
      CAST(wo_closed_mb_5."AMOS_MOBILE" AS integer) * 100.0 / CAST(wo_total_5."TOTAL_WO_CLOSED" AS integer)
   ) AS "PERCENT_AMOS_MOBILE_5",
   ROUND(
      CAST(wo_closed_mb_6."AMOS_MOBILE" AS integer) * 100.0 / CAST(wo_total_6."TOTAL_WO_CLOSED" AS integer)
   ) AS "PERCENT_AMOS_MOBILE_6",
   ROUND(
      CAST(wo_closed_mb_7."AMOS_MOBILE" AS integer) * 100.0 / CAST(wo_total_7."TOTAL_WO_CLOSED" AS integer)
   ) AS "PERCENT_AMOS_MOBILE_7"
FROM
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "TOTAL_WO_CLOSED" -- Count total WO closed
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '1 day') :: date
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
         AND bohi_changes.action LIKE '%anually closed%'
         AND (
            wp_header.wpno NOT LIKE '%VJC%'
            OR wp_header.wpno IS NULL
         )
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_total,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "AMOS_MOBILE" -- Count distinct WO CLOSED BY AMOS MOBILE
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '1 day') :: date
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
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_closed_mb,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "TOTAL_WO_CLOSED" -- Count total WO closed
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '2 day') :: date
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
         AND bohi_changes.action LIKE '%anually closed%'
         AND (
            wp_header.wpno NOT LIKE '%VJC%'
            OR wp_header.wpno IS NULL
         )
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_total_2,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "AMOS_MOBILE" -- Count distinct WO CLOSED BY AMOS MOBILE
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '2 day') :: date
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
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_closed_mb_2,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "TOTAL_WO_CLOSED" -- Count total WO closed
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '3 day') :: date
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
         AND bohi_changes.action LIKE '%anually closed%'
         AND (
            wp_header.wpno NOT LIKE '%VJC%'
            OR wp_header.wpno IS NULL
         )
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_total_3,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "AMOS_MOBILE" -- Count distinct WO CLOSED BY AMOS MOBILE
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '3 day') :: date
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
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_closed_mb_3,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "TOTAL_WO_CLOSED" -- Count total WO closed
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '4 day') :: date
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
         AND bohi_changes.action LIKE '%anually closed%'
         AND (
            wp_header.wpno NOT LIKE '%VJC%'
            OR wp_header.wpno IS NULL
         )
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_total_4,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "AMOS_MOBILE" -- Count distinct WO CLOSED BY AMOS MOBILE
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '4 day') :: date
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
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_closed_mb_4,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "TOTAL_WO_CLOSED" -- Count total WO closed
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '5 day') :: date
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
         AND bohi_changes.action LIKE '%anually closed%'
         AND (
            wp_header.wpno NOT LIKE '%VJC%'
            OR wp_header.wpno IS NULL
         )
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_total_5,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "AMOS_MOBILE" -- Count distinct WO CLOSED BY AMOS MOBILE
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '5 day') :: date
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
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_closed_mb_5,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "TOTAL_WO_CLOSED" -- Count total WO closed
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '6 day') :: date
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
         AND bohi_changes.action LIKE '%anually closed%'
         AND (
            wp_header.wpno NOT LIKE '%VJC%'
            OR wp_header.wpno IS NULL
         )
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_total_6,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "AMOS_MOBILE" -- Count distinct WO CLOSED BY AMOS MOBILE
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '6 day') :: date
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
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_closed_mb_6,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "TOTAL_WO_CLOSED" -- Count total WO closed
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '7 day') :: date
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
         AND bohi_changes.action LIKE '%anually closed%'
         AND (
            wp_header.wpno NOT LIKE '%VJC%'
            OR wp_header.wpno IS NULL
         )
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_total_7,
   (
      SELECT
         COUNT(DISTINCT wo_header.event_perfno_i) AS "AMOS_MOBILE" -- Count distinct WO CLOSED BY AMOS MOBILE
      FROM
         wo_header full
         JOIN bohi_version ON wo_header.event_perfno_i = bohi_version.primkey
         JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i
         LEFT JOIN sign ON wo_header.mech_sign = sign.user_sign
         LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
         LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
      WHERE
         (DATE '1971-12-31' + wo_header.closing_date) :: date = (current_timestamp - interval '7 day') :: date
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
         AND wo_header.mech_sign NOT IN ('VJC1273', 'VJC13794')
         AND wo_header.mech_sign LIKE 'VJC%'
   ) wo_closed_mb_7