SELECT 
    COUNT(CASE WHEN workgroup = 'AMO_SG_T1' THEN 1 END) AS "SG_T1_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_SG_T2' THEN 1 END) AS "SG_T2_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_SG_T3' THEN 1 END) AS "SG_T3_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_SG_T4' THEN 1 END) AS "SG_T4_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_SG_T5' THEN 1 END) AS "SG_T5_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_SG_T6' THEN 1 END) AS "SG_T6_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_SG_STR' THEN 1 END) AS "SG_STR_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_SG_CAB' THEN 1 END) AS "SG_CAB_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_SG_330' THEN 1 END) AS "SG_330_TOTAL",
    COUNT(user_sign) AS "TOTAL_RESOURCE"
FROM 
    sign
WHERE 
    department = 'VJC AMO'
    AND status = 0
    AND homebase = 'SGN'
    AND
    ((
    workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            parent = 29760)
    ) OR workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            parent = 29748
    )
    )