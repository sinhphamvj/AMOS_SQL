SELECT 
    -- Tổng số user dept = AMO VJC
    MAX(CASE WHEN "DEPT" = 'AMO' THEN "RESOURCE_COUNT" ELSE 0 END) AS "AMO_TOTAL",
    
    -- Tổng số user MOC
    MAX(CASE WHEN "DEPT" = 'MOC' THEN "RESOURCE_COUNT" ELSE 0 END) AS "MOC_TOTAL",
    
    -- Total resource AMO
    (MAX(CASE WHEN "DEPT" = 'AMO' THEN "RESOURCE_COUNT" ELSE 0 END)+
    MAX(CASE WHEN "DEPT" = 'MOC' THEN "RESOURCE_COUNT" ELSE 0 END)) AS "TOTAL_RESOURCE"

FROM (
    -- Query
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'AMO' AS "DEPT"
    FROM sign
    WHERE 
    department = 'VJC AMO'
    AND status = 0

    UNION ALL
    -- Query
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'MOC' AS "DEPT"
    FROM sign
    WHERE 
    status = 0
    AND shift_group LIKE 'MOC%'
    ) AS resource_count