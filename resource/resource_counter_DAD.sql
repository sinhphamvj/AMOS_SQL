SELECT 
    COUNT(CASE WHEN workgroup = 'AMO_DN_T1' THEN 1 END) AS "DN_T1_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_T2' THEN 1 END) AS "DN_T2_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_T3' THEN 1 END) AS "DN_T3_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_T4' THEN 1 END) AS "DN_T4_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_T5' THEN 1 END) AS "DN_T5_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_T6' THEN 1 END) AS "DN_T6_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_STR' THEN 1 END) AS "DN_STR_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_CAB' THEN 1 END) AS "DN_CAB_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_DRV' THEN 1 END) AS "DN_DRV_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_PPC' THEN 1 END) AS "DN_PPC_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DN_STO' THEN 1 END) AS "DN_STO_TOTAL",
    COUNT(CASE WHEN workgroup = 'AMO_DAD_SM' THEN 1 END) AS "DN_SM_TOTAL",
    COUNT(user_sign) AS "TOTAL_RESOURCE"
FROM 
    sign
WHERE 
    department = 'VJC AMO'
    AND status = 0
    AND
    ((
    workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            parent = 29848)
    ) OR workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            parent = 29849
    )OR workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            address_i = 29848
    ))