SELECT pickslip_header.pickslipno,
       TO_CHAR(DATE '1971-12-31' + pickslip_header.pickslip_date, 'DD.MON.YYYY') AS "ISSUE_DATE",
       pickslip_header.mech_sign,
       pickslip_header.receiver
FROM pickslip_header
JOIN pickslip_booked ON pickslip_header.pickslipno = pickslip_booked.pickslipno 
AND pickslip_booked.partno = '980-6022-001' AND pickslip_booked.serialno = '2745' 
AND pickslip_header.station_from = pickslip_header.station_to 
AND pickslip_header.station_to = 'SGN' 
AND pickslip_header.store_to = 'MAIN' 
AND pickslip_booked.status = 9

ORDER BY pickslip_header.pickslip_date DESC NULLS LAST  
