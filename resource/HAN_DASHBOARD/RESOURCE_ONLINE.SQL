SELECT
-- Tổng số user ONLINE
 MAX(CASE WHEN "USER" = 'ONLINE' THEN "MPWR_COUNT" ELSE 0 END) AS "ONLINE_TOTAL",
-- Tổng số user 
 MAX(CASE WHEN "USER" = 'HAN' THEN "MPWR_COUNT" ELSE 0 END) AS "USER_TOTAL",
-- Tổng số user OFFLINE
 MAX(CASE WHEN "USER" = 'HAN' THEN "MPWR_COUNT" ELSE 0 END) - 
 MAX(CASE WHEN "USER" = 'ONLINE' THEN "MPWR_COUNT" ELSE 0 END) AS "OFFLINE_TOTAL"

FROM(
    -- Query số user ONLINE
   SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "MPWR_COUNT", 'ONLINE' AS "USER"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sp_user_availability.shift_id
    WHERE 
    (DATE '1971-12-31' + start_date)::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND (
        (
              (current_timestamp + INTERVAL '7 hours')::time BETWEEN '08:00:00' AND '20:00:00'
            AND (entry_type IN ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7','EC','B1_O','HC','BD1','BD5_O','OT_M','SBD1','OBD1','BD5_O','BD1_O')
                 OR (entry_type IN ('OT_O','BD3','BD3_O') AND start_time BETWEEN 0 AND 540)
            )
        )OR (
               (current_timestamp + INTERVAL '7 hours')::time NOT BETWEEN '08:00:00' AND '20:00:00'
            AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E','B2_O','BD2','OT_N','SBD2','OBD2','BD2_O')
            OR (entry_type IN ('OT_O','OT_N','BD3','BD3_O') AND start_time BETWEEN 540 AND 1440)
            )
        )
    )
    AND sign.status <> 9
    AND sp_shift.location = 'HAN'
UNION ALL
    -- Query số user HAN
    SELECT COUNT(DISTINCT user_sign) AS "MPWR_COUNT", 'HAN' AS "USER"
    FROM sign
    WHERE
    department = 'VJC AMO'
    AND status <> 9
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                               address_i IN(29877,29878,29879,29880,29881,29869,29870,29871,29911,29868,29919, 29909,29874,29913,29873,29910, 29872)

                    ) 
    
                  
)AS MANPOWER_COUNT