SELECT
wo_header.event_perfno_i as "WO",
wo_header.ac_registr as "AC_REG",
TO_CHAR(DATE '1971-12-31' + wo_header.issue_date, 'DD.MON.YYYY') AS "ISSUE_DATE",
TO_CHAR(DATE '1971-12-31' + forecast_dimension.expected_date, 'DD.MON.YYYY') AS "DUE_DATE",
wo_text_description.header as "DESCRIPTION",
wp_header.wpno as "WP_NAME",
wo_remarks.text as "REMARKS"
FROM wo_header
LEFT JOIN wo_header_4 ON wo_header.event_perfno_i = wo_header_4.event_perfno_i
LEFT JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i
LEFT JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
LEFT JOIN forecast_dimension ON wo_header.event_perfno_i = forecast_dimension.event_perfno_i
LEFT JOIN wp_assignment ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
LEFT JOIN wp_header ON wp_assignment.wpno_i = wp_header.wpno_i
LEFT JOIN wo_remarks ON wo_header.event_perfno_i = wo_remarks.event_perfno_i
WHERE
wo_header.type = 'S'
AND wo_header.state = 'O'
AND wo_header.issue_sign IN ('VJC11532', 'VJC10830', 'VJC12532', 'VJC9016', 'VJC6814', 'VJC4676', 'VJC4700', 'VJC6277', 'VJC10891', 'VJC11458', 'VJC6825', 'VJC9014')
AND wo_header_4.event_type_mandatory = 'WR'
AND (DATE '1971-12-31' + wo_header.issue_date)::DATE >= TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
ORDER BY
wo_header.ac_registr