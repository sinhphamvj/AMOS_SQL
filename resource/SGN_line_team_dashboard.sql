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
    --Tổng số user TEAM 6
    MAX(CASE WHEN "TEAM" = 'T6' THEN "MPWR_COUNT" ELSE 0 END) AS "T6_TOTAL",
    --Tổng số user TEAM 330
    MAX(CASE WHEN "TEAM" = 'T330' THEN "MPWR_COUNT" ELSE 0 END) AS "T330_TOTAL",
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
                                  address_i =  29749 --AMO SGN TEAM 1
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
                                  address_i =  29750 --AMO SGN TEAM 2
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
                                    address_i =  29751 --AMO SGN TEAM 3
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
                                    address_i =  29752 --AMO SGN TEAM 4
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
                                    address_i =  29753 --AMO SGN TEAM 5
                        )
UNION ALL
    -- Query số User TEAM 6
    SELECT COUNT(user_sign) AS "MPWR_COUNT", 'T6' AS "TEAM"
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
                                    address_i =  29754 --AMO SGN TEAM 6
                        )
UNION ALL
    -- Query số User TEAM 330
    SELECT COUNT(user_sign) AS "MPWR_COUNT", 'T330' AS "TEAM"
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
                                    address_i =  29758 --AMO SGN TEAM 330
                        )

) AS mpwr_count
