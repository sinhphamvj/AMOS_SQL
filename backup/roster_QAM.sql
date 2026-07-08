SELECT
    DENSE_RANK() OVER (ORDER BY s.user_sign) AS STT,
    s.user_sign,
    s.firstname, 
    s.status,
    s.lastname, 
    s.employee_no, 
    s.auth_number,
    s.jobcode,
    s.mech_stamp,
    spq.notes,
    spq.limitation,
    spq.pqs_type_no_i,
    TO_CHAR(DATE '1971-12-31'+ spq.issue_date,'DD Mon YYYY') AS issue_date,
    TO_CHAR(DATE '1971-12-31'+ spq.expiry_date,'DD Mon YYYY') AS expiry_date,
    sqs.type_label,
    COALESCE(aml.aml_expiry_date, 'N/A') AS aml_expiry_date
FROM sign s
JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i
JOIN staff_pqs_type sqs ON spq.pqs_type_no_i = sqs.pqs_type_no_i
JOIN staff_pqs_class spc ON spc.pqs_class_no_i = sqs.pqs_class_no_i
LEFT JOIN (
    SELECT
        spq.employee_no_i,
        TO_CHAR(DATE '1971-12-31' + MAX(spq.expiry_date), 'DD Mon YYYY') AS aml_expiry_date
    FROM
        staff_pqs_qualification spq
    JOIN staff_pqs_type sqs ON sqs.pqs_type_no_i = spq.pqs_type_no_i
    WHERE
        sqs.type_label = 'ARS'
    GROUP BY
        spq.employee_no_i
) aml ON aml.employee_no_i = s.employee_no_i
WHERE 
    spc.pqs_class_id LIKE 'AUTH'
    AND sqs.type_label IN ('SQM','QFS','BSI')
    AND s.status=0
    AND s.auth_number LIKE '%VJC.%'
ORDER BY STT