SELECT DISTINCT ON (wo_header.ac_registr)
       event_template.template_revisionno_i,
       wo_header.event_perfno_i AS "WO",
       wo_header.ac_registr AS "AC_REG",
       TO_CHAR(DATE '1971-12-31' + wo_header.closing_date, 'DD.MON.YYYY') AS "CLOSED_DATE"

FROM wo_header
JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
WHERE event_template.wtno_i IN (280832, 280413,281041)
AND wo_header.event_type = 'JC'
AND wo_header.state = 'C'
AND wo_header.event_perfno_i > 0
AND (DATE '1971-12-31' + wo_header.closing_date) :: date >= (current_timestamp - interval '10 day') :: date
ORDER BY wo_header.ac_registr, wo_header.event_perfno_i DESC
