SELECT 
    -- Tổng số user TEAM 1
    MAX(CASE WHEN "TEAM" = 'T1' THEN "MPWR_COUNT" ELSE 0 END) AS "T1_TOTAL",
    --Tổng số user TEAM 2
    MAX(CASE WHEN "TEAM" = 'T2' THEN "MPWR_COUNT" ELSE 0 END) AS "T2_TOTAL",
    --Tổng số user TEAM 3
    MAX(CASE WHEN "TEAM" = 'T3' THEN "MPWR_COUNT" ELSE 0 END) AS "T3_TOTAL",
    --Tổng số user TEAM 4  
    MAX(CASE WHEN "TEAM" = 'T4' THEN "MPWR_COUNT" ELSE 0 END) AS "T4_TOTAL",
    --Tổng số user TEAM 5
    MAX(CASE WHEN "TEAM" = 'T5' THEN "MPWR_COUNT" ELSE 0 END) AS "T5_TOTAL",
    -- Tổng số user ALL TEAM
    SUM("MPWR_COUNT") AS "TOTAL_MPWR"
FROM (
    -- Query số user TEAM 1
    SELECT COUNT(user_sign) AS "MPWR_COUNT", 'T1' AS "TEAM"
    FROM sign
    WHERE 
    department = 'VJC AMO'
    AND status = 0
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                                  address_i =  29877 --AMO HAN TEAM 1
                    )

    UNION ALL
    -- Query số User TEAM 2
    SELECT COUNT(user_sign) AS "MPWR_COUNT", 'T2' AS "TEAM"
    FROM sign
    WHERE   
    department = 'VJC AMO'
    AND status = 0  
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                                  address_i =  29878--AMO HAN TEAM 2
                    )
    UNION ALL
    -- Query số User TEAM 3
    SELECT COUNT(user_sign) AS "MPWR_COUNT", 'T3' AS "TEAM"    
    FROM sign
    WHERE   
    department = 'VJC AMO'
    AND status = 0  
    AND workgroup IN
    (
                            SELECT
                                vendor
                            FROM address
                            WHERE
                                    address_i =  29879 --AMO HAN TEAM 3
                        )
UNION ALL
    -- Query số User TEAM 4
    SELECT COUNT(user_sign) AS "MPWR_COUNT", 'T4' AS "TEAM"    
    FROM sign
    WHERE   
    department = 'VJC AMO'
    AND status = 0  
    AND workgroup IN
    (
                            SELECT
                                vendor
                            FROM address
                            WHERE
                                    address_i =  29880 --AMO HAN TEAM 4
                        )
UNION ALL
    -- Query số User TEAM 5
    SELECT COUNT(user_sign) AS "MPWR_COUNT", 'T5' AS "TEAM"
    FROM sign
    WHERE   
    department = 'VJC AMO'
    AND status = 0  
    AND workgroup IN
    (
                            SELECT
                                vendor
                            FROM address
                            WHERE
                                    address_i =  29881 --AMO HAN TEAM 5
                        )

) AS mpwr_count