SELECT
-- Tổng số user ONLINE
 MAX(CASE WHEN "USER" = 'ONLINE' THEN "MPWR_COUNT" ELSE 0 END) AS "ONLINE_TOTAL",
-- Tổng số user 
 MAX(CASE WHEN "USER" = 'SGN' THEN "MPWR_COUNT" ELSE 0 END) AS "USER_TOTAL",
-- Tổng số user OFFLINE
 MAX(CASE WHEN "USER" = 'SGN' THEN "MPWR_COUNT" ELSE 0 END) - 
 MAX(CASE WHEN "USER" = 'ONLINE' THEN "MPWR_COUNT" ELSE 0 END) AS "OFFLINE_TOTAL"

FROM(
    -- Query số user ONLINE
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "MPWR_COUNT", 'ONLINE' AS "USER"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    WHERE 
    (
        DATE '1971-12-31' + start_date + CASE
            WHEN start_time + 420 >= 1440 THEN 1
            ELSE 0
        END
    )::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND (
        (
            (current_timestamp + INTERVAL '7 hours')::time BETWEEN '05:00:00' AND '17:00:00'
            AND (entry_type IN ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7','EC','B1_O','HC')
                OR (entry_type IN('OT','B17') AND end_time <= 720)
            )
        )OR (
            (current_timestamp + INTERVAL '7 hours')::time NOT BETWEEN '05:00:00' AND '17:00:00'
            AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E','B2_O')
                OR (entry_type = 'OT' AND end_time > 720)
            )
        )
    )
    AND sign.status <> 9
AND sign.homebase = 'SGN'
UNION ALL
    -- Query số user SGN
    SELECT COUNT(DISTINCT user_sign) AS "MPWR_COUNT", 'SGN' AS "USER"
    FROM sign
    WHERE
    department = 'VJC AMO'
    AND status <> 9
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                               address_i IN(29749,29750,29751,29752,29753,29754,29758)

                    ) 
    
                  
)AS MANPOWER_COUNT