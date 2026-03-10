SELECT 
    TO_CHAR(DATE '1971-12-31' + pqs.start_date::INTEGER,'DD/MM/YYYY') AS pqs_start_date,
    TO_CHAR(DATE '1971-12-31' + pqs.end_date::INTEGER,'DD/MM/YYYY') AS pqs_end_date,
    MAX(CASE WHEN rpv.property_type_no_i = 2281 THEN rpv.char_value END) AS major,
    MAX(CASE WHEN rpv.property_type_no_i = 2381 THEN rpv.char_value END) AS training_org,
    MAX(CASE WHEN rpv.property_type_no_i = 2282 THEN rpv.char_value END) AS form_of_training,
    MAX(CASE WHEN rpv.property_type_no_i = 2283 THEN rpv.char_value END) AS degree_diploma_cert
FROM sign s
LEFT JOIN staff_pqs_qualification pqs
    ON pqs.employee_no_i = s.employee_no_i
JOIN rm_property_value rpv
    ON rpv.owner_amos_key = pqs.pqs_qualification_no_i
WHERE
    s.user_sign='@VAR.VJCID@'
    AND rpv.owner_amos_type = 'PQSE'
AND pqs.pqs_type_no_i= 12173
GROUP BY s.employee_no_i, pqs.start_date, pqs.end_date
