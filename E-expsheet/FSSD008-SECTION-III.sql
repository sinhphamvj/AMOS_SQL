SELECT 
    TO_CHAR(DATE '1971-12-31' + pqs.start_date::INTEGER,'DD/MM/YYYY') AS pqs_start_date,
    TO_CHAR(DATE '1971-12-31' + pqs.end_date::INTEGER,'DD/MM/YYYY') AS pqs_end_date,
    spt.type_description,
    pqc.pqs_class_id,
    pqc.label,
    COALESCE(MAX(CASE WHEN rpv.property_type_no_i = 2281 THEN rpv.char_value END), spt.type_description) AS major,
    COALESCE(MAX(CASE WHEN rpv.property_type_no_i = 2381 THEN rpv.char_value END), 'HỌC VIỆN HÀNG KHÔNG VICTORIA') AS training_org,
    COALESCE(MAX(CASE WHEN rpv.property_type_no_i = 2282 THEN rpv.char_value END), 'Lý thuyết + Thực hành') AS form_of_training,
    COALESCE(MAX(CASE WHEN rpv.property_type_no_i = 2283 THEN rpv.char_value END), 'Chứng Chỉ') AS degree_diploma_cert
FROM sign s
LEFT JOIN staff_pqs_qualification pqs ON pqs.employee_no_i = s.employee_no_i
LEFT JOIN staff_pqs_type spt ON spt.pqs_type_no_i = pqs.pqs_type_no_i
LEFT JOIN staff_pqs_class pqc ON pqc.pqs_class_no_i = spt.pqs_class_no_i
LEFT JOIN rm_property_value rpv ON rpv.owner_amos_key = pqs.pqs_qualification_no_i
WHERE
    s.user_sign='VJC2741'
    AND (spt.pqs_type_no_i = 894 OR spt.pqs_type_no_i = 374
         OR (pqs.pqs_type_no_i = 12173 AND rpv.owner_amos_type = 'PQSE'))
GROUP BY s.employee_no_i, pqs.start_date, pqs.end_date, spt.type_description, pqc.pqs_class_id, pqc.label
