SELECT 
    sub.employee_no_i
FROM (
    SELECT 
        sign.employee_no_i,
        ROW_NUMBER() OVER (PARTITION BY sign.user_sign ORDER BY spq.expiry_date ASC) as rn
    FROM sign
    LEFT JOIN staff_pqs_qualification spq ON spq.employee_no_i = sign.employee_no_i
    LEFT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i
    WHERE staff_pqs_type.type_label = 'AMT'
    AND sign.status = 0
    AND spq.status = 0
    AND (DATE '1971-12-31' + spq.expiry_date) BETWEEN TO_DATE('@VAR.START_DATE@', 'DD.MON.YYYY') AND TO_DATE('@VAR.END_DATE@', 'DD.MON.YYYY')
) sub
WHERE rn = 1