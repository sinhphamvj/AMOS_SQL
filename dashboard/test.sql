SELECT
   CAST(mdr.dailyrecno_i AS INT) AS "DAILYRECNO",
   mdr.event_perfno_i AS "WO"
FROM moc_daily_records mdr
WHERE mdr.event_group IN ('DLYRP')
   AND mdr.closed <> 'Y'
   AND mdr.event_type IN ('AOG')
ORDER BY mdr.event_type, DATE '1971-12-31' + mdr.occurance_date

---------------


SELECT     CAST(mdr.dailyrecno_i AS INT) AS "DAILYRECNO",
       mdr.event_perfno_i AS "WO",
       mdr.event_type AS "EVENT_TYPE",
       mdr.ac_registr AS "AC_REG",
       mdr.rep_station AS "STATION",
       TO_CHAR(
          DATE '1971-12-31' + mdr.occurance_date ,
          'DD.MON.YYYY'
       ) as "ISS_DATE",
       mdr.header AS "DEFECT",
       mdr.description AS "ACTION_TAKEN",
       mdn.mutation_time,
       mdn.text AS REMARK 
FROM moc_daily_records mdr 
JOIN (
        SELECT dailyrecno_i,
               MAX(mutation_time) AS max_time     
        FROM moc_daily_note     
        GROUP BY dailyrecno_i 
     ) max_mdn ON mdr.dailyrecno_i = max_mdn.dailyrecno_i 
JOIN moc_daily_note mdn ON mdn.dailyrecno_i = max_mdn.dailyrecno_i AND mdn.mutation_time = max_mdn.max_time 
WHERE mdr.dailyrecno_i = @DLYRP_AOG_ID.DAILYRECNO@ 
ORDER BY mdr.event_type,
         DATE '1971-12-31' + mdr.occurance_date