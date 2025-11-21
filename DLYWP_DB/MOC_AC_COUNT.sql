SELECT
    total_ac_query."TOTAL_AC",
    total_aog_query."TOTAL_AOG",
    total_plan_inprocess_query."TOTAL_PLAN_INPROCESS",
    total_ac_query."TOTAL_AC" - (total_aog_query."TOTAL_AOG" + total_plan_inprocess_query."TOTAL_PLAN_INPROCESS") AS "TOTAL_AC_AVAIL",
    c_chk_query."TOTAL_C_CHK",
    a_chk_query."TOTAL_A_CHK",
    o_chk_query."TOTAL_O_CHK",
    coa_query."TOTAL_COA",
    pk_mt_query."TOTAL_PK_MT",
    st_mt_query."TOTAL_ST_MT"
FROM
    -- Total number of aircraft
    (SELECT COUNT(*) AS "TOTAL_AC"
     FROM aircraft
     WHERE operator = 'VJC'
       AND non_managed = 'N'
       AND ac_typ IN ('A330F', 'A321FL', 'A320')) total_ac_query,
       
    -- Total number of AOG events
    (SELECT COUNT(*) AS "TOTAL_AOG"
     FROM moc_daily_records mdr
     WHERE mdr.event_type = 'AOG'
       AND mdr.closed <> 'Y') total_aog_query,
       
    -- Total number of PLAN_INPROCESS events
    (SELECT COUNT(DISTINCT mdr.ac_registr) AS "TOTAL_PLAN_INPROCESS"
     FROM moc_daily_records mdr
     WHERE mdr.event_group IN ('DLYRP') 
       AND mdr.closed <> 'Y'
       AND mdr.event_type IN ('C_CHK', 'A_CHK', 'O_CHK', 'COA', 'PK_MT', 'ST_MT')
 AND ((mdr.occurance_date * 24 * 60) + mdr.occurance_time) <= 
      (((CURRENT_DATE - DATE '1971-12-31') * 24 * 60) + (EXTRACT(HOUR FROM CURRENT_TIME) * 60 + EXTRACT(MINUTE FROM CURRENT_TIME)))
    ) total_plan_inprocess_query,
    
    -- Total number of C_CHK events
    (SELECT COUNT(*) AS "TOTAL_C_CHK"
     FROM moc_daily_records mdr
     WHERE mdr.event_type = 'C_CHK'
       AND mdr.closed <> 'Y' 
 AND ((mdr.occurance_date * 24 * 60) + mdr.occurance_time) <= 
      (((CURRENT_DATE - DATE '1971-12-31') * 24 * 60) + (EXTRACT(HOUR FROM CURRENT_TIME) * 60 + EXTRACT(MINUTE FROM CURRENT_TIME)))
) c_chk_query,
       
    -- Total number of A_CHK events
    (SELECT COUNT(*) AS "TOTAL_A_CHK"
     FROM moc_daily_records mdr
     WHERE mdr.event_type = 'A_CHK'
       AND mdr.closed <> 'Y'
 AND ((mdr.occurance_date * 24 * 60) + mdr.occurance_time) <= 
      (((CURRENT_DATE - DATE '1971-12-31') * 24 * 60) + (EXTRACT(HOUR FROM CURRENT_TIME) * 60 + EXTRACT(MINUTE FROM CURRENT_TIME)))
) a_chk_query,
       
    -- Total number of O_CHK events
    (SELECT COUNT(*) AS "TOTAL_O_CHK"
     FROM moc_daily_records mdr
     WHERE mdr.event_type = 'O_CHK'
       AND mdr.closed <> 'Y'
 AND ((mdr.occurance_date * 24 * 60) + mdr.occurance_time) <= 
      (((CURRENT_DATE - DATE '1971-12-31') * 24 * 60) + (EXTRACT(HOUR FROM CURRENT_TIME) * 60 + EXTRACT(MINUTE FROM CURRENT_TIME)))
) o_chk_query,
       
    -- Total number of COA events
    (SELECT COUNT(*) AS "TOTAL_COA"
     FROM moc_daily_records mdr
     WHERE mdr.event_type = 'COA'
       AND mdr.closed <> 'Y'
 AND ((mdr.occurance_date * 24 * 60) + mdr.occurance_time) <= 
      (((CURRENT_DATE - DATE '1971-12-31') * 24 * 60) + (EXTRACT(HOUR FROM CURRENT_TIME) * 60 + EXTRACT(MINUTE FROM CURRENT_TIME)))
) coa_query,
       
    -- Total number of PK_MT events
    (SELECT COUNT(*) AS "TOTAL_PK_MT"
     FROM moc_daily_records mdr
     WHERE mdr.event_type = 'PK_MT'
       AND mdr.closed <> 'Y') pk_mt_query,
       
    -- Total number of ST_MT events
    (SELECT COUNT(*) AS "TOTAL_ST_MT"
     FROM moc_daily_records mdr
     WHERE mdr.event_type = 'ST_MT'
       AND mdr.closed <> 'Y') st_mt_query
