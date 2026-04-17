SELECT 
    valid_staff.firstname, 
    valid_staff.lastname, 
    TO_CHAR(DATE '1971-12-31' + sign.first_crs_date, 'DD Mon YYYY') AS first_crs_date,
    valid_staff.employee_no, 
    valid_staff.auth_number,
    valid_staff.mech_stamp,
    valid_staff.notes,
    valid_staff.limitation,
    valid_staff.pqs_type_no_i,
    valid_staff.special_text_1, 
    valid_staff.expiry_date,
    staff_pqs_type.type_label 
FROM staff_pqs_type
RIGHT JOIN (
    SELECT DISTINCT 
        s.firstname,
        s.lastname,
        s.employee_no,
        s.employee_no_i,
        s.auth_number,
        s.mech_stamp, 
        spq.notes, 
        spq.limitation, 
        spq.pqs_type_no_i,  
        TO_CHAR(DATE '1971-12-31' + spq.expiry_date, 'DD Mon YYYY') AS expiry_date,
        spq.special_text_1 
    FROM sign s   
    LEFT JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i
    LEFT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i  
    WHERE s.employee_no_i NOT IN (
        SELECT s.employee_no_i
        FROM sign s
        LEFT JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i 
        LEFT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i 
        LEFT JOIN staff_pqs_class ON staff_pqs_type.pqs_class_no_i = staff_pqs_class.pqs_class_no_i
        WHERE spq.expiry_date <= CURRENT_DATE - '1971-12-31'
            AND spq.expiry_date IS NOT NULL
            AND (s.auth_number LIKE '%VJC.STORE.INSP%')  
            AND staff_pqs_type.type_label <> 'PROC TVJ' 
            AND staff_pqs_class.pqs_class_id <> 'RECURRENT'
            AND spq.status = 0
    )
    AND s.employee_no_i NOT IN (
        SELECT s.employee_no_i
        FROM sign s
        RIGHT JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i 
        RIGHT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i 
        RIGHT JOIN staff_pqs_class ON staff_pqs_type.pqs_class_no_i = staff_pqs_class.pqs_class_no_i
        WHERE staff_pqs_type.type_label = 'SPS' 
            AND spq.status = 0
    )
) valid_staff ON valid_staff.pqs_type_no_i = staff_pqs_type.pqs_type_no_i
LEFT JOIN sign ON sign.employee_no_i = valid_staff.employee_no_i
WHERE staff_pqs_type.type_description = 'VJC AUTH'
    AND valid_staff.auth_number LIKE '%VJC.STORE.INSP%'
    AND sign.status = 0
ORDER BY valid_staff.auth_number
