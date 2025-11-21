SELECT
   "AC_REG",
   "STATION",
   "WP_NAME",
   "START_DATE",
   "START_TIME",
   "END_DATE",
   "END_TIME",
   "GROUND_TIME",
   "PRI",
   "JC_LINK_WO_NUM",
   "JC_TEAMPLATE_NUM",
   "JC_DESC_HEADER",
   "ACTION_TAKEN",
   "ACTION_TAKEN_HTML",
   "VJCID",
   "REASON",
   "REMARKS"
FROM
   (
      SELECT
         inner_query.*,
         ROW_NUMBER() OVER (
            PARTITION BY "JC_LINK_WO_NUM"
            ORDER BY
               CASE
                  WHEN "REASON" IS NOT NULL THEN 0
                  ELSE 1
               END
         ) as rn
      FROM
         (
            ---- Subquery for wp_content
            SELECT
               wp_header.ac_registr AS "AC_REG",
               wp_header.station AS "STATION",
               wp_header.wpno AS "WP_NAME",
               TO_CHAR(
                  DATE '1971-12-31' + wp_header.start_date,
                  'DD.MON.YYYY'
               ) AS "START_DATE",
               CASE
                  WHEN (wp_header.start_time + 420) >= 1440 THEN TO_CHAR(
                     TIME '00:00' + (
                        (wp_header.start_time + 420 - 1440) || ' minutes'
                     ) :: interval,
                     'HH24:MI'
                  ) || '+'
                  ELSE TO_CHAR(
                     TIME '00:00' + ((wp_header.start_time + 420) || ' minutes') :: interval,
                     'HH24:MI'
                  )
               END AS "START_TIME",
               TO_CHAR(
                  DATE '1971-12-31' + wp_header.end_date,
                  'DD.MON.YYYY'
               ) AS "END_DATE",
               CASE
                  WHEN (wp_header.end_time + 420) >= 1440 THEN TO_CHAR(
                     TIME '00:00' + ((wp_header.end_time + 420 - 1440) || ' minutes') :: interval,
                     'HH24:MI'
                  ) || '+'
                  ELSE TO_CHAR(
                     TIME '00:00' + ((wp_header.end_time + 420) || ' minutes') :: interval,
                     'HH24:MI'
                  )
               END AS "END_TIME",
               TO_CHAR(
                  TIME '00:00' + (
                     CASE
                        WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
                        ELSE wp_header.end_time - wp_header.start_time
                     END || ' minutes'
                  ) :: interval,
                  'HH24:MI'
               ) AS "GROUND_TIME",
               wo_header.prio AS "PRI",
               wp_content.event_perfno_i AS "JC_LINK_WO_NUM",
               work_template.template_number AS "JC_TEAMPLATE_NUM",
               wo_text_description.header AS "JC_DESC_HEADER",
               wo_text_description.text AS "ACTION_TAKEN",
               wo_text_description.text_html AS "ACTION_TAKEN_HTML",
               wp_content.created_by AS "VJCID",
               wp_content.reason AS "REASON",
               wp_content.remarks AS "REMARKS"
            FROM
               wp_content
               JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i
               left join wo_header on wp_content.event_perfno_i = wo_header.event_perfno_i
               left join workstep_link on wo_header.event_perfno_i = workstep_link.event_perfno_i
               left join wo_text_description on workstep_link.descno_i = wo_text_description.descno_i
               LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
               LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
            WHERE
               wp_header.wpno_i IN (@VAR.WP @)
               and work_template.template_number LIKE '%@VAR.WO@%'
            UNION
            -- Subquery for wp_assignment
            SELECT
               wp_header.ac_registr AS "AC_REG",
               wp_header.station AS "STATION",
               wp_header.wpno AS "WP_NAME",
               TO_CHAR(
                  DATE '1971-12-31' + wp_header.start_date,
                  'DD.MON.YYYY'
               ) AS "START_DATE",
               CASE
                  WHEN (wp_header.start_time + 420) >= 1440 THEN TO_CHAR(
                     TIME '00:00' + (
                        (wp_header.start_time + 420 - 1440) || ' minutes'
                     ) :: interval,
                     'HH24:MI'
                  ) || '+'
                  ELSE TO_CHAR(
                     TIME '00:00' + ((wp_header.start_time + 420) || ' minutes') :: interval,
                     'HH24:MI'
                  )
               END AS "START_TIME",
               TO_CHAR(
                  DATE '1971-12-31' + wp_header.end_date,
                  'DD.MON.YYYY'
               ) AS "END_DATE",
               CASE
                  WHEN (wp_header.end_time + 420) >= 1440 THEN TO_CHAR(
                     TIME '00:00' + ((wp_header.end_time + 420 - 1440) || ' minutes') :: interval,
                     'HH24:MI'
                  ) || '+'
                  ELSE TO_CHAR(
                     TIME '00:00' + ((wp_header.end_time + 420) || ' minutes') :: interval,
                     'HH24:MI'
                  )
               END AS "END_TIME",
               TO_CHAR(
                  TIME '00:00' + (
                     CASE
                        WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
                        ELSE wp_header.end_time - wp_header.start_time
                     END || ' minutes'
                  ) :: interval,
                  'HH24:MI'
               ) AS "GROUND_TIME",
               wo_header.prio AS "PRI",
               wp_assignment.event_perfno_i AS "JC_LINK_WO_NUM",
               work_template.template_number AS "JC_TEAMPLATE_NUM",
               wo_text_description.header AS "JC_DESC_HEADER",
               wo_text_description.text AS "ACTION_TAKEN",
               wo_text_description.text_html AS "ACTION_TAKEN_HTML",
               wo_header.mech_sign AS "VJCID",
               NULL AS "REASON",
               NULL AS "REMARKS"
            FROM
               wp_assignment
               JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i
               JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
               left join workstep_link on wo_header.event_perfno_i = workstep_link.event_perfno_i
               left join wo_text_description on workstep_link.descno_i = wo_text_description.descno_i
               LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
               LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
            WHERE
               wp_header.wpno_i IN (@VAR.WP @)
               and work_template.template_number LIKE '%@VAR.WO@%'
         ) AS inner_query
   ) AS ranked_query
WHERE
   rn = 1
ORDER BY
   CASE
      WHEN "STATION" = 'SGN' THEN 1
      WHEN "STATION" = 'HAN' THEN 2
      WHEN "STATION" = 'DAD' THEN 3
      WHEN "STATION" = 'CXR' THEN 4
      WHEN "STATION" = 'HPH' THEN 5
      WHEN "STATION" = 'VCA' THEN 6
      WHEN "STATION" = 'PQC' THEN 7
      ELSE 8
   END,
   "AC_REG"