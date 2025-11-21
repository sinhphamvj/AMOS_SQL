SELECT
   CAST(wo_over_due."WO_OVER_DUE" AS integer) AS "WO_OVER_DUE",
   CAST(label_booking."LABEL_NOT_BOOK" AS integer) AS "LABEL_NOT_BOOK",
   CAST(wo_closed_mb."AMOS_MOBILE" AS integer) * 100.0 / CAST(wo_total."TOTAL_WO_CLOSED" AS integer) AS "PERCENT_AMOS_MOBILE"
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
         COUNT(wo_part_on_off.status) AS "LABEL_NOT_BOOK"
      FROM
         wo_part_on_off full
         JOIN wo_header ON wo_part_on_off.event_perfno_i = wo_header.event_perfno_i
      WHERE
         (DATE '1971-12-31' + wo_part_on_off.created_date) :: date = (current_timestamp - interval '1 day') :: date
         and (wo_part_on_off.status = 0)
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
   ) label_booking,
   (
      SELECT
         COUNT(wh.event_perfno_i) AS "WO_OVER_DUE" --count WO overdue
      FROM
         wo_header as wh
         LEFT JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
         LEFT JOIN forecast_dimension AS fd ON wh.event_perfno_i = fd.event_perfno_i
         LEFT JOIN aircraft ON wh.ac_registr = aircraft.ac_registr
      WHERE
         wh.ac_registr NOT IN (
            SELECT
               mdr.ac_registr
            FROM
               moc_daily_records mdr
            WHERE
               mdr.event_group IN ('DLYRP')
               AND mdr.closed <> 'Y'
               AND mdr.event_type IN (
                  'C_CHK',
                  'A_CHK',
                  'O_CHK',
                  'PK_MT',
                  'ST_MT',
                  'AOG'
               )
               AND (
                  (mdr.occurance_date * 24 * 60) + mdr.occurance_time
               ) <= (
                  ((CURRENT_DATE - DATE '1971-12-31') * 24 * 60) + (
                     EXTRACT(
                        HOUR
                        FROM
                           CURRENT_TIME
                     ) * 60 + EXTRACT(
                        MINUTE
                        FROM
                           CURRENT_TIME
                     )
                  )
               )
         )
         AND wh.state = 'O'
         AND wh.type = 'S'
         AND (
            (DATE '1971-12-31' + fd.expected_date) :: date < current_timestamp :: date
         )
         AND wh.type != 'PD'
         AND aircraft.non_managed = 'N'
         AND aircraft.is_mod_controlled = 'Y'
         AND aircraft.operator = 'VJC'
         AND aircraft.ac_typ IN ('A330F', 'A321FL', 'A320')
   ) wo_over_due