SELECT 
    -- Tổng số user dept = MAITNENANCE
    MAX(CASE WHEN "DEPT" = 'MAINT' THEN "RESOURCE_COUNT" ELSE 0 END) AS "MAINT_TOTAL",
     -- Tổng số user dept = OFFICE
    MAX(CASE WHEN "DEPT" = 'OFFICE' THEN "RESOURCE_COUNT" ELSE 0 END) AS "OFFICE_TOTAL",
        
    -- Tổng số user dept = SPECIAL
    MAX(CASE WHEN "DEPT" = 'VTE' THEN "RESOURCE_COUNT" ELSE 0 END) AS "VTE_DUTY_TOTAL",

    -- Tổng số user dept = THD
    MAX(CASE WHEN "DEPT" = 'THD' THEN "RESOURCE_COUNT" ELSE 0 END) AS "THD_TOTAL",

    -- Tổng số user dept = GSE and WA
    MAX(CASE WHEN "DEPT" = 'GSE_WS' THEN "RESOURCE_COUNT" ELSE 0 END) AS "GSE_WS_TOTAL",
    -- Tổng số user dept = CABIN
    MAX(CASE WHEN "DEPT" = 'CABIN' THEN "RESOURCE_COUNT" ELSE 0 END) AS "CABIN_TOTAL",
    --Tổng số user dept = STORE
    MAX(CASE WHEN "DEPT" = 'STO' THEN "RESOURCE_COUNT" ELSE 0 END) AS "STO_TOTAL",
    --Tổng số user dept = DRIVER
    MAX(CASE WHEN "DEPT" = 'DRIVER' THEN "RESOURCE_COUNT" ELSE 0 END) AS "DRIVER_TOTAL",

-- Tổng số user dept = OTHER (VTE+THD+DRIVER)
    SUM(CASE WHEN "DEPT" IN ('THD','VTE','DRIVER') THEN "RESOURCE_COUNT" ELSE 0 END) AS "OTHER_TEAMS",

 -- Tổng số user dept = SPECIAL TEAM (GSE_WS+CABIN+STO)
    SUM(CASE WHEN "DEPT" IN ('GSE_WS','CABIN','STO') THEN "RESOURCE_COUNT" ELSE 0 END) AS "SPECIAL_TEAMS",
    -- Tổng số user dept = ALL
    SUM("RESOURCE_COUNT")::INTEGER AS "ALL_TOTAL" 

FROM (
    -- Query số User Maintenance
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'MAINT' AS "DEPT"
    FROM sign
    WHERE 
    status = 0
    AND department = 'VJC AMO'
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            parent =  29869 OR address_i IN(29877,29878,29879,29880,29881,29869)-- T1,T2,T3,T4,,T5
                    )
    UNION ALL
    -- Query số User Office      
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'OFFICE' AS "DEPT"    
    FROM sign
    WHERE 
    status = 0
    AND department = 'VJC AMO'
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i IN (29870,29871,29911,29868) -- ADMIN,PPC,DATA ENTRY , HOD
                    ) 
    UNION ALL
    -- Query số User DUTY AT VTE  
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'VTE' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'  
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 29919 -- AMO HAN LINE FOR VTE PERSON
                    )

    
    UNION ALL
    -- Query tổng số user THD
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'THD' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'      
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 29909 -- AMO THD_LM
                    )
    UNION ALL
    -- Query tổng số user GSE and WS
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'GSE_WS' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'          
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i IN (29874,29913) -- HAN GSE and WS         
            )

    UNION ALL
    -- Query tổng số user DEPT = CABIN
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'CABIN' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'              
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 29873 -- AMO CABIN HAN
    )  
    UNION ALL
    -- Query tổng số user DEPT = STO
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'STO' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'          
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 29872 -- HAN STORE
    )
    UNION ALL
    -- Query tổng số user DEPT = DRIVER
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'DRIVER' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'          
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 29910 -- HAN DRIVER
    )
) AS resource_count