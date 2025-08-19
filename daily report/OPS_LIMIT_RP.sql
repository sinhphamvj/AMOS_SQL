SELECT DISTINCT ON (pf.partno,pf.requested_qty, pf.part_request_created_date)
    wh.event_perfno_i AS "WO",
   pf.partno AS "PART_NO",
   pf.part_description AS "PART_DESC",
TO_CHAR( DATE '1971-12-31' + pf.part_request_created_date,'DD.MON.YYYY') AS "REQ_DATE", 
   pf.requested_qty AS "REQ_QTY",
    pf.accessable_system_qty AS "STOCK_QTY",
           COALESCE(
          rp.total_rotable_value,
          cp.total_consumable_value,
          0
       ) AS "TOTAL_STOCK_QTY",
   prei.remarks AS "REMARKS"
FROM wo_header AS wh
LEFT JOIN part_forecast AS pf ON wh.event_perfno_i = pf.event_perfno_i
LEFT JOIN part_request_event_inf prei ON pf.partno = prei.partno
LEFT JOIN (
             SELECT partno,
                    SUM(custom_value) AS total_rotable_value   
             FROM (
                     SELECT part_location.partno,
                            0.0 AS custom_value     
                     FROM part_location     
                     JOIN location ON part_location.locationno_i = location.locationno_i     
                     WHERE location.station <> 'BKK'       
                           AND location.location_type <> -107       
                           AND location.location_restriction = 0     
                     UNION ALL     
                     SELECT rotables.partno,
                            1.0 AS custom_value     
                     FROM rotables     
                     JOIN location ON rotables.locationno_i = location.locationno_i     
                     WHERE rotables.ac_registr IN (
                              '',
                              'TRANSF'
                           )       
                           AND rotables.condition <> 'US'       
                           AND location.station <> 'BKK'       
                           AND location.location_type <> -107       
                           AND location.location_restriction = 0       
                           AND rotables.partnonew = ''   
                  ) AS combined   
             GROUP BY partno 
          ) rp ON pf.partno = rp.partno AND pf.mat_class = 'R' 
LEFT JOIN (
    SELECT pl.partno, SUM(CASE
        WHEN c.qty IS NOT NULL THEN c.qty
        ELSE 0.0
    END) AS total_consumable_value
    FROM part_location pl
    LEFT JOIN consumables c ON pl.partno = c.partno AND pl.locationno_i = c.locationno_i
    JOIN location l ON pl.locationno_i = l.locationno_i
    WHERE l.station <> 'BKK'
      AND l.location_type <> -107
      AND l.location_restriction = 0
    GROUP BY pl.partno
) cp ON pf.partno = cp.partno AND pf.mat_class = 'C' 
WHERE
    wh.event_perfno_i =  @MOPS_OTHERS.WO@ 

AND (
         COALESCE(
            rp.total_rotable_value,
            cp.total_consumable_value,
            0
         ) = 0   
         OR COALESCE(
            rp.total_rotable_value,
            cp.total_consumable_value,
            0
         ) < pf.requested_qty 
      )
      AND (pf.accessable_system_qty = 0 OR pf.requested_qty > pf.accessable_system_qty)
ORDER BY pf.partno,pf.requested_qty, pf.part_request_created_date,pf.mutation DESC