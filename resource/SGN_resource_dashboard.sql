SELECT 
    -- Tổng số user dept = HOD
    MAX(CASE WHEN "DEPT" = 'HOD' THEN "RESOURCE_COUNT" ELSE 0 END) AS "HOD_TOTAL",
    
    -- Tổng số user dept = MAITNENANCE
    MAX(CASE WHEN "DEPT" = 'MAINT' THEN "RESOURCE_COUNT" ELSE 0 END) AS "MAINT_TOTAL",

     -- Tổng số user dept = OFFICE
    MAX(CASE WHEN "DEPT" = 'OFFICE' THEN "RESOURCE_COUNT" ELSE 0 END) AS "OFFICE_TOTAL",
        
    -- Tổng số user dept = SPECIAL
    MAX(CASE WHEN "DEPT" = 'SPECIAL' THEN "RESOURCE_COUNT" ELSE 0 END) AS "SPECIAL_TOTAL",

    -- Tổng số user dept = BMV
    MAX(CASE WHEN "DEPT" = 'BMV' THEN "RESOURCE_COUNT" ELSE 0 END) AS "BMV_TOTAL",
    -- Tổng số user dept = DLI
    MAX(CASE WHEN "DEPT" = 'DLI' THEN "RESOURCE_COUNT" ELSE 0 END) AS "DLI_TOTAL",
    -- Tổng số user dept = BSI
    MAX(CASE WHEN "DEPT" = 'BSI' THEN "RESOURCE_COUNT" ELSE 0 END) AS "BSI_TOTAL",
    -- Tổng số user dept = CABIN
    MAX(CASE WHEN "DEPT" = 'CABIN' THEN "RESOURCE_COUNT" ELSE 0 END) AS "CABIN_TOTAL",
    -- Tổng số user dept = STRUCTURE
    MAX(CASE WHEN "DEPT" = 'STRUCTURE' THEN "RESOURCE_COUNT" ELSE 0 END) AS "STRUCTURE_TOTAL",
    -- Tổng số user dept = OTHER (BSI+CABIN+STRUCTURE)
    SUM(CASE WHEN "DEPT" IN ('BSI', 'CABIN', 'STRUCTURE') THEN "RESOURCE_COUNT" ELSE 0 END) AS "OTHER",
    -- Tổng số user dept = OUTSTATION (BMV+DLI+SPECIAL)
    SUM(CASE WHEN "DEPT" IN ('BMV', 'DLI','SPECIAL') THEN "RESOURCE_COUNT" ELSE 0 END) AS "OUTSTATION",
    -- Tổng số user dept = ALL
    SUM("RESOURCE_COUNT")::INTEGER AS "ALL_TOTAL" 

FROM (
    -- Query số user HOD
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'HOD' AS "DEPT"
    FROM sign
    WHERE 
    department = 'VJC AMO'
    AND status = 0
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                                  address_i =  29760 --AMO SGN STATION MANAGER 
                    )

    UNION ALL
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
                            parent =  29748 OR address_i IN(29764,30049,30050,30147,30048,29760)
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
                            address_i IN (29762,29766,29847,29761)
                    ) 
    UNION ALL
    -- Query số User Special    
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'SPECIAL' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'  
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 30147 -- AMO SGN LINE FOR VTE PERSON
                    )
                    
    UNION ALL
    -- Query tổng số user BMV
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'BMV' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'      
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 29882 -- AMO BMV
                    )
    UNION ALL
    -- Query tổng số user DLI
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'DLI' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'          
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 29883 -- AMO DLI         
            )
UNION ALL
    -- Query tổng số user DEPT = BSI
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'BSI' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'          
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 29765 -- AMO BSI
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
                            address_i = 29756 -- AMO CABIN
    ) 
    UNION ALL
    -- Query tổng số user DEPT = STRUCTURE
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'STRUCTURE' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'          
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i = 29755 -- AMO STRUCTURE
    )     
) AS resource_count
