/* 
 Tablet list for this query:
 
 wo_header
 wo_header_more
 wo_header_4
 wo_transfer
 workstep_link
 wo_text_description
 sign
 ac_utilization
 wo_text_action
 db_link
 wo_transfer_dimension
 counter
 counter_template
 counter_definition
 aircraft
 There are a total of 15 tables used in this code.
 
 */
SELECT
   wo_header.event_perfno_i,
   CASE
      wo_header.mel_code
      WHEN 'L' THEN 'N/A'
      ELSE wo_header.mel_code
   END as mel_code2,
   TO_CHAR(
      DATE '1971-12-31' + wo_header.issue_date,
      'DD MON YYYY'
   ),
   wo_header.issue_station,
   wo_header.ac_registr,
   last_transfer.name_last,
   last_transfer.name_first,
   last_transfer.auth_no,
   wo_header_more.mel_chapter,
   wo_header_4.chk_ops_consequence,
   last_transfer.tf_stn,
   TO_CHAR(
      DATE '1971-12-31' + last_transfer.tf_date,
      'DD MON YYYY'
   ) AS tf_date,
   rep_maint_ref.rep_maint_desc,
   wo_last_workstep.description,
   db_link.link_remarks,
   due_tah.due_TAH,
   due_tac.due_TAC,
   wo_transfer.absolute_due_date,
   CASE
      WHEN db_link.link_remarks IS NULL THEN TO_CHAR(
         DATE '1971-12-31' + wo_transfer.absolute_due_date,
         'DD MON YYYY'
      )
      WHEN CAST(
         db_link.link_remarks AS VARCHAR(24)
      ) = '' THEN TO_CHAR(
         DATE '1971-12-31' + wo_transfer.absolute_due_date,
         'DD MON YYYY'
      )
      ELSE CAST(
         db_link.link_remarks AS VARCHAR(24)
      )
   END AS due_Date,
   wo_transfer.absolute_due_time,
   CASE
      wo_header.mel_code
      WHEN 'L' THEN 'CDL'
      WHEN 'A' THEN 'MEL'
      WHEN 'B' THEN 'MEL'
      WHEN 'C' THEN 'MEL'
      WHEN 'D' THEN 'MEL'
      ELSE ''
   END as add_type
FROM
   wo_header
   LEFT JOIN wo_header_more ON wo_header.event_perfno_i = wo_header_more.event_perfno_i
   LEFT JOIN wo_header_4 ON wo_header.event_perfno_i = wo_header_4.event_perfno_i
   LEFT JOIN wo_transfer ON wo_header.event_perfno_i = wo_transfer.event_perfno_i
   LEFT JOIN (
      SELECT
         workstep_link.event_perfno_i AS wo_no,
         wo_text_description.text AS description
      FROM
         workstep_link
         LEFT JOIN wo_text_description ON wo_text_description.descno_i = workstep_link.descno_i
      WHERE
         wo_text_description.descno_i IN (
            SELECT
               MAX(wo_text_description.descno_i)
            FROM
               wo_text_description
               LEFT JOIN workstep_link ON wo_text_description.descno_i = workstep_link.descno_i
            GROUP BY
               workstep_link.event_perfno_i
         )
   ) wo_last_workstep ON wo_last_workstep.wo_no = wo_header.event_perfno_i
   LEFT JOIN (
      SELECT
         event_perfno_i AS wo_no,
         transfer_station AS tf_stn,
         date_transfer AS tf_date,
         sign.lastname AS name_last,
         sign.firstname AS name_first,
         sign.auth_number AS auth_no
      FROM
         wo_transfer
         LEFT JOIN sign ON wo_transfer.user_sign = sign.user_sign
      WHERE
         wo_transfer.is_last_transfer = 'Y'
   ) last_transfer ON wo_header.event_perfno_i = last_transfer.wo_no
   LEFT JOIN ac_utilization ON wo_transfer.legno_i = ac_utilization.legno_i
   LEFT JOIN wo_text_action ON wo_transfer.actionno_i = wo_text_action.actionno_i
   LEFT JOIN db_link ON wo_header.event_perfno_i = CAST(db_link.source_pk AS INT)
   LEFT JOIN (
      SELECT
         event_transferno_i,
         wo_transfer_dimension.counterno_i,
         CAST(
            CAST(
               (wo_transfer_dimension.due_at :: INT) / 60 AS INT
            ) AS VARCHAR
         ) || ':' || RIGHT(
            TO_CHAR(
               (wo_transfer_dimension.due_at || 'SECOND') :: INTERVAL,
               'HH24:MI:SS'
            ),
            2
         ) AS due_TAH
      FROM
         wo_transfer_dimension
         LEFT JOIN counter ON wo_transfer_dimension.counterno_i = counter.counterno_i
         LEFT JOIN counter_template ON counter.counter_templateno_i = counter_template.counter_templateno_i
         LEFT JOIN counter_definition ON counter_template.counter_defno_i = counter_definition.counter_defno_i
      WHERE
         counter_definition.code = 'H'
   ) due_tah ON due_tah.event_transferno_i = wo_transfer.event_transferno_i
   LEFT JOIN (
      SELECT
         event_transferno_i,
         wo_transfer_dimension.counterno_i,
         CAST(wo_transfer_dimension.due_at AS INT) AS due_TAC
      FROM
         wo_transfer_dimension
         LEFT JOIN counter ON wo_transfer_dimension.counterno_i = counter.counterno_i
         LEFT JOIN counter_template ON counter.counter_templateno_i = counter_template.counter_templateno_i
         LEFT JOIN counter_definition ON counter_template.counter_defno_i = counter_definition.counter_defno_i
      WHERE
         counter_definition.code = 'C'
   ) due_tac ON due_tac.event_transferno_i = wo_transfer.event_transferno_i
   LEFT JOIN (
      SELECT
         description AS rep_maint_desc,
         CAST(source_pk AS INT) AS source_no
      FROM
         db_link
      WHERE
         source_type = 'WO'
         AND ref_type = 'REP_MNT'
   ) rep_maint_ref ON wo_header.event_perfno_i = rep_maint_ref.source_no
WHERE
   wo_header.event_perfno_i > 0
   AND wo_header.workorderno_display IS NOT NULL
   AND (
      wo_header.event_type NOT IN (
         'Q',
         'T',
         'J'
      )
   )
   AND EXISTS (
      SELECT
         aircraft.ac_registr
      FROM
         aircraft
      WHERE
         wo_header.ac_registr = aircraft.ac_registr
         AND aircraft.ac_registr = '@VAR.ACReg@'
   )
   AND wo_header.type IN (
      'P',
      'M',
      'C',
      'S'
   )
   AND (
      wo_header.mel_code IN (
         'A',
         'B',
         'C',
         'D',
         'L',
         'F'
      )
      OR wo_header.hil = 'Y'
   )
   AND wo_header.state = 'O'
   AND wo_header_more.wo_class IN (
      'A',
      'L',
      'T'
   )
   AND wo_transfer.is_last_transfer = 'Y'
   AND db_link.source_type = 'WO'
   AND db_link.ref_type = 'ADD'
ORDER BY
   wo_header.issue_date
   /*addition for issue_dater*/