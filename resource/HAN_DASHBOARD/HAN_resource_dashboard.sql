SELECT 
    MAX(CASE WHEN "DEPT" = 'ONLINE' THEN "RESOURCE_COUNT" ELSE 0 END) AS "ONLINE_TOTAL",
    SUM(CASE WHEN "DEPT" NOT IN ('ONLINE', 'DUTYTRAVEL', 'TRAINING', 'DO_AL') THEN "RESOURCE_COUNT" ELSE 0 END)::INTEGER AS "ALL_TOTAL",
    (SUM(CASE WHEN "DEPT" NOT IN ('ONLINE', 'DUTYTRAVEL', 'TRAINING', 'DO_AL') THEN "RESOURCE_COUNT" ELSE 0 END) - 
    MAX(CASE WHEN "DEPT" = 'ONLINE' THEN "RESOURCE_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "DEPT" = 'DUTYTRAVEL' THEN "RESOURCE_COUNT" ELSE 0 END)-
    MAX(CASE WHEN "DEPT" = 'TRAINING' THEN "RESOURCE_COUNT" ELSE 0 END)
    )::INTEGER AS "OFFLINE_TOTAL",
    MAX(CASE WHEN "DEPT" = 'DUTYTRAVEL' THEN "RESOURCE_COUNT" ELSE 0 END) AS "DUTYTRAVEL_TOTAL",
    MAX(CASE WHEN "DEPT" = 'TRAINING' THEN "RESOURCE_COUNT" ELSE 0 END) AS "TRAINING_TOTAL",
    MAX(CASE WHEN "DEPT" = 'DO_AL' THEN "RESOURCE_COUNT" ELSE 0 END) AS "DO_AL_TOTAL"

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
    SELECT COUNT(user_sign) AS "RESOURCE_COUNT", 'CABIN_STR' AS "DEPT"    
    FROM sign
    WHERE       
    status = 0
    AND department = 'VJC AMO'              
    AND workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                            address_i IN (29873,29876) -- AMO CABIN & STRUCTURE HAN
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
    UNION ALL

        -- Query số user ONLINE
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'ONLINE' AS "DEPT"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sp_user_availability.shift_id
    WHERE 
    (DATE '1971-12-31' + start_date)::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND (
        (
              (current_timestamp + INTERVAL '7 hours')::time BETWEEN '08:00:00' AND '20:00:00'
            AND (entry_type IN ('B1', 'B11', 'B12', 'B16', 'B20', 'B21', 'B3', 'B5', 'B7','EC','B1_O','HC','BD1','BD5_O','OT_M')
                 OR (entry_type IN('BD3','BD3_O') AND start_time < 840)
            )
        )OR (
               (current_timestamp + INTERVAL '7 hours')::time NOT BETWEEN '08:00:00' AND '20:00:00'
            AND (entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E','B2_O','BD2','OT_N')
            OR (entry_type IN('BD3','BD3_O') AND start_time >= 840)
            )
        )
    )
    AND sign.status <> 9
    AND sp_shift.location = 'HAN'

    -- Query số user DUTYTRAVEL
    UNION ALL
    SELECT COUNT(DISTINCT sp_user_availability.user_sign) AS "RESOURCE_COUNT", 'DUTYTRAVEL' AS "DEPT"
    FROM sp_user_availability
    LEFT JOIN sign ON sp_user_availability.user_sign = sign.user_sign
    LEFT JOIN sp_shift ON sp_shift.shift_id = sp_user_availability.shift_id
    WHERE 
    (DATE '1971-12-31' + start_date)::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
    AND entry_type IN ('FE','FE_DYG','FE_HKT','FE_HND','FE_NGO','DT','DT_PUS','DT_DPS','DT_ICN','DT_PQC','DT_SIN','T_REP','FE_BQS', 'FE_CJJ', 'FE_CZX', 'FE_DYG_1', 'FE_FUK', 'FE_GAY', 'FE_HIJ', 'FE_KHV', 'FE_KIX', 'FE_NGO_1', 'FE_NRT', 'FE_PKX', 'FE_TAK', 'FE_VNS', 'FE_VOO')  
    AND sign.status <> 9
    AND sp_shift.location = 'HAN'

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
    AND sp_shift.location = 'HAN'
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
    AND sp_shift.location = 'HAN'
) AS resource_count