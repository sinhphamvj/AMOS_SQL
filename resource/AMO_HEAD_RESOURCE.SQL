SELECT 
    COUNT(CASE WHEN workgroup = 'AMO_ADFIN' THEN 1 END) AS "ADFIN_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_ICT' THEN 1 END) AS "AMO_ICT_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_TRAINING' THEN 1 END) AS "TRAINING_TOTAL",
    COUNT(user_sign) AS "TOTAL_RESOURCE"
FROM 
    sign
WHERE 
    department = 'VJC AMO'
    AND status = 0
    AND
    (
    workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            parent (30146,29918)
    )
   )