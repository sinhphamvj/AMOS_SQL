SELECT 
    MAX(CASE WHEN "DEPT" = 'ONLINE' THEN "RESOURCE_COUNT" ELSE 0 END) AS "ONLINE_TOTAL",
    SUM(CASE WHEN "DEPT" IN ('AMO', 'MQA') THEN "RESOURCE_COUNT" ELSE 0 END)::INTEGER AS "ALL_TOTAL",
    (SUM(CASE WHEN "DEPT" IN ('AMO', 'MQA') THEN "RESOURCE_COUNT" ELSE 0 END) - 
    MAX(CASE WHEN "DEPT" = 'ONLINE' THEN "RESOURCE_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "DEPT" = 'DUTYTRAVEL' THEN "RESOURCE_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "DEPT" = 'TRAINING' THEN "RESOURCE_COUNT" ELSE 0 END)
    )::INTEGER AS "OFFLINE_TOTAL",
    MAX(CASE WHEN "DEPT" = 'DUTYTRAVEL' THEN "RESOURCE_COUNT" ELSE 0 END) AS "DUTYTRAVEL_TOTAL",
    MAX(CASE WHEN "DEPT" = 'TRAINING' THEN "RESOURCE_COUNT" ELSE 0 END) AS "TRAINING_TOTAL",
    MAX(CASE WHEN "DEPT" = 'DO_AL' THEN "RESOURCE_COUNT" ELSE 0 END) AS "DO_AL_TOTAL",
    MAX(CASE WHEN "DEPT" = 'AMO' THEN "RESOURCE_COUNT" ELSE 0 END) AS "AMO_TOTAL",
    MAX(CASE WHEN "DEPT" = 'MQA' THEN "RESOURCE_COUNT" ELSE 0 END) AS "MQA_TOTAL"

FROM (
       -- Query total MP at dept = AMO VJC
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'AMO' AS "DEPT"
    FROM sign
    WHERE 
    department = 'VJC AMO'
    AND status = 0
   --Query total MP at dept = AMO_MQA
    UNION ALL
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'MQA' AS "DEPT"
    FROM sign
    WHERE 
    department = 'AMO_QA'
    AND status = 0
    UNION ALL
        -- Query số user ONLINE
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'ONLINE' AS "DEPT"
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
            AND (entry_type IN ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7','EC','B1_O','HC','OT_M','VC5','K1','E1','E1_O','B9','BD1','BD5_O')
                OR (entry_type IN('OT','B17','B18','BD3','BD3_O') AND start_time < 840)
            )
        )OR (
            (current_timestamp + INTERVAL '7 hours')::time NOT BETWEEN '05:00:00' AND '17:00:00'
            AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E','B2_O','OT_N','K2','E2','E2_O','CK','BD2')
                OR (entry_type IN('OT','B17','B18','BD3','BD3_O') AND start_time > 840)
            )
        )
    )
    AND sign.status <> 9

    -- Query số user DUTYTRAVEL
    UNION ALL
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'DUTYTRAVEL' AS "DEPT"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    WHERE 
    (DATE '1971-12-31' + start_date)::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND entry_type IN ('FE','FE_DYG','FE_HKT','FE_HND','FE_NGO','DT','DT_PUS','DT_DPS','DT_ICN','DT_PQC','DT_SIN','T_REP')  
    AND sign.status <> 9

    -- Query số user TRAINING
    UNION ALL
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'TRAINING' AS "DEPT"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    WHERE 
    (DATE '1971-12-31' + start_date)::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND entry_type IN ('T')   
    AND sign.status <> 9
    -- Query số user DO_AL
    UNION ALL
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'DO_AL' AS "DEPT"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    WHERE 
    (DATE '1971-12-31' + start_date)::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND entry_type IN ('DO','AL','UL','H','LW','ML','WS','PL','VS','KT','S')   
    AND sign.status <> 9
) AS resource_count