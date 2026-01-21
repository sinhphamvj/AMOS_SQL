SELECT  
    s.user_sign, 
    cus.type_special_text_1, 
    cus.type_description,  
    cus.issue_date,
    CASE 
        WHEN cus.type_description IS NULL THEN NULL
        WHEN cus.type_description IS NOT NULL THEN spq.special_text_2
    END AS system,
    CASE 
        WHEN cus.type_description IS NULL THEN NULL
        WHEN cus.type_description IS NOT NULL THEN spq.notes
    END AS scope,
    CASE 
        WHEN cus.type_description IS NULL THEN NULL
        WHEN cus.type_description IS NOT NULL THEN 
            CASE 
                WHEN UPPER(spq.notes) LIKE '%A/B2%' THEN 'CAT A/B2'
                WHEN UPPER(spq.notes) LIKE '%A/B1%' THEN 'CAT A/B1'
                WHEN UPPER(spq.notes) LIKE '%B1S%' THEN 'CAT B1S'
                WHEN UPPER(spq.notes) LIKE '%B2S%' THEN 'CAT B2S'
                WHEN UPPER(spq.notes) LIKE '%B1%' THEN 'CAT B1'
                WHEN UPPER(spq.notes) LIKE '%B2%' THEN 'CAT B2'
                WHEN UPPER(spq.notes) LIKE '%ARS%' THEN 'CAT ARS'
                WHEN UPPER(spq.notes) LIKE '%A%' THEN 'CAT A'
                WHEN UPPER(spq.notes) LIKE '%C%' THEN 'CAT C'
                ELSE NULL
            END
    END AS category,
   CASE WHEN  cus.type_description   IS NULL THEN NULL	
                  WHEN  cus.type_description   IS NOT NULL THEN spq.limitation
       END AS actype,
       CASE WHEN  cus.type_description   IS NULL THEN NULL	
                  WHEN  cus.type_description   IS NOT NULL THEN spq.special_text_1
       END AS limitation 
FROM sign s 
LEFT JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i  
LEFT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i  
LEFT JOIN staff_pqs_class ON staff_pqs_type.pqs_class_no_i = staff_pqs_class.pqs_class_no_i 
LEFT JOIN (
    SELECT 
        staff_pqs_type.type_description, 
        s.user_sign,
        staff_pqs_type.type_special_text_1,
        TO_CHAR(DATE '1971-12-31' + spq.issue_date, 'DD Mon YYYY') AS issue_date
    FROM sign s
    LEFT JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i
    LEFT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i
    LEFT JOIN staff_pqs_class ON staff_pqs_type.pqs_class_no_i = staff_pqs_class.pqs_class_no_i
    WHERE s.user_sign = '@VJC_ID@'
        AND staff_pqs_class.pqs_class_id = 'CUS_AUTH'
) cus ON cus.user_sign = s.user_sign 
WHERE s.user_sign = '@VJC_ID@'
    -- Áp dụng điều kiện type_label cho toàn bộ truy vấn
    AND (UPPER(staff_pqs_type.type_label) IN ('TVJ', 'IGO') 
         OR staff_pqs_type.type_label IS NULL)
    -- BẮT BUỘC TRONG SCOPE PHẢI CÓ 1 TRONG CÁC KÍ TỰ
    AND (
        UPPER(spq.notes) LIKE '%B1%' 
        OR UPPER(spq.notes) LIKE '%B2%'
        OR UPPER(spq.notes) LIKE '%A%'
        OR UPPER(spq.notes) LIKE '%B1S%'
        OR UPPER(spq.notes) LIKE '%B2S%'
        OR UPPER(spq.notes) LIKE '%C%'
        OR UPPER(spq.notes) LIKE '%ARS%'
        OR UPPER(spq.notes) LIKE '%A/B2%'
        OR UPPER(spq.notes) LIKE '%A/B1%'
    )