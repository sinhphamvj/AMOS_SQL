SELECT 
    MAX(CASE WHEN "DEPT" = 'ONLINE' THEN "RESOURCE_COUNT" ELSE 0 END) AS "ONLINE_TOTAL",
    MAX(CASE WHEN "DEPT" = 'TOTAL' THEN "RESOURCE_COUNT" ELSE 0 END)::INTEGER AS "ALL_TOTAL",
    (MAX(CASE WHEN "DEPT" = 'TOTAL' THEN "RESOURCE_COUNT" ELSE 0 END) - 
    MAX(CASE WHEN "DEPT" = 'ONLINE' THEN "RESOURCE_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "DEPT" = 'DUTYTRAVEL' THEN "RESOURCE_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "DEPT" = 'TRAINING' THEN "RESOURCE_COUNT" ELSE 0 END)
    )::INTEGER AS "OFFLINE_TOTAL",
    MAX(CASE WHEN "DEPT" = 'DUTYTRAVEL' THEN "RESOURCE_COUNT" ELSE 0 END) AS "DUTYTRAVEL_TOTAL",
    MAX(CASE WHEN "DEPT" = 'TRAINING' THEN "RESOURCE_COUNT" ELSE 0 END) AS "TRAINING_TOTAL",
    MAX(CASE WHEN "DEPT" = 'DO_AL' THEN "RESOURCE_COUNT" ELSE 0 END) AS "DO_AL_TOTAL"

FROM (
    -- Query số user DAD\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'TOTAL' AS "DEPT"
    FROM sign
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
    UNION ALL
        -- Query số user ONLINE
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'ONLINE' AS "DEPT"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sp_user_availability.shift_id
    WHERE 
    (
        DATE '1971-12-31' + start_date + CASE
            WHEN start_time + 420 >= 1440 THEN 1
            ELSE 0
        END
    )::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND (
        (
            (current_timestamp + INTERVAL '7 hours')::time BETWEEN '06:00:00' AND '18:00:00'
            AND (entry_type IN ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7','EC','B1_O','HC','OT_M','E1','E1_O','E9')
                OR (entry_type IN('OT','B17') AND end_time <= 720)
            )
        )OR (
            (current_timestamp + INTERVAL '7 hours')::time NOT BETWEEN '06:00:00' AND '18:00:00'
            AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E','B2_O','OT_N','E2','E2_O','CK','E10','E4','E4_O')
                OR (entry_type IN ('OT','B17') AND end_time > 720)
            )
        )
    )
    AND sign.status <> 9
    AND sp_shift.location = 'DAD'

    -- Query số user DUTYTRAVEL
    UNION ALL
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'DUTYTRAVEL' AS "DEPT"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sp_user_availability.shift_id
    WHERE 
    (DATE '1971-12-31' + start_date)::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND entry_type IN ('FE','FE_DYG','FE_HKT','FE_HND','FE_NGO','DT','DT_PUS','DT_DPS','DT_ICN','DT_PQC','DT_SIN','T_REP')  
    AND sign.status <> 9
    AND sp_shift.location = 'DAD'

    -- Query số user TRAINING
    UNION ALL
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'TRAINING' AS "DEPT"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sp_user_availability.shift_id
    WHERE 
    (DATE '1971-12-31' + start_date)::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND entry_type IN ('T')   
    AND sign.status <> 9
    AND sp_shift.location = 'DAD'
    -- Query số user DO_AL
    UNION ALL
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'DO_AL' AS "DEPT"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sp_user_availability.shift_id
    WHERE 
    (DATE '1971-12-31' + start_date)::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND entry_type IN ('DO','AL','UL','H','LW','ML','WS','PL','VS','KT','S')   
    AND sign.status <> 9
    AND sp_shift.location = 'DAD'
) AS resource_count