SELECT
r.partno,
    r.serialno,
    COUNT(*) AS "TOTAL ROB"
FROM 
    rotables r
LEFT JOIN 
    location ON r.locationno_i = location.locationno_i
LEFT JOIN 
    od_rec_detail ON r.rec_detailno_i = od_rec_detail.recdetailno_i
LEFT JOIN 
    od_header ON r.orderno = od_header.orderno AND (od_header.orderno <> '')
LEFT JOIN 
    aircraft ON r.ac_registr = aircraft.ac_registr AND (aircraft.ac_registr <> '')
LEFT JOIN 
    db_link ON CAST(r.psn AS TEXT) = db_link.source_pk
LEFT JOIN 
    forecast ON r.partno = forecast.partno AND r.serialno = forecast.serialno
LEFT JOIN 
    wo_header ON wo_header.event_perfno_i = forecast.event_perfno_i
WHERE 
    r.partno IN ('3800454-6', '3800708-1', 'PW1133GA-JM', 'CFM56-5B3/3', 'CFM56-5B4/3', 'TRENT772B60-16')
    AND db_link.description = 'MOC'
    AND db_link.source_type = 'RO'
    AND wo_header.state = 'O'
    AND wo_header.type = 'S'
GROUP BY
r.partno, 
    r.serialno
ORDER BY
r.partno,
    r.serialno