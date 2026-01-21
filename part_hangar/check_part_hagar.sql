SELECT DISTINCT ON (rotables.partno, rotables.serialno) 
rotables.locationno_i,
rotables.partno as "PN",
rotables.serialno AS "SN",
pickslip_header.pickslipno AS "PICKSLIP",
TO_CHAR(DATE '1971-12-31' + pickslip_header.pickslip_date, 'DD.MON.YYYY') AS "ISSUE_DATE",
pickslip_header.mech_sign AS "MECH_SIGN",
pickslip_header.station_to AS "STATION",
pickslip_header.receiver AS "AC",
pickslip_header.event_type,
pickslip_header.event_key AS "WO",
pickslip_header.remarks AS "REMARKS",
pickslip_header.pickslip_text,
pickslip_booked.status AS "BOOKED_STATUS"
FROM
rotables
LEFT JOIN pickslip_booked ON rotables.partno = pickslip_booked.partno AND rotables.serialno = pickslip_booked.serialno
LEFT JOIN part ON rotables.partno = part.partno AND part.mat_class = 'R'
LEFT JOIN pickslip_header ON pickslip_header.pickslipno = pickslip_booked.pickslipno
LEFT JOIN sign ON pickslip_header.mech_sign = sign.user_sign
WHERE
rotables.location = 'HANGAR'
AND pickslip_booked.status = 9
AND pickslip_booked.location_to <> 'TRANSFER'
AND ((DATE '1971-12-31' + pickslip_header.pickslip_date)::DATE >= TO_DATE('31.DEC.2024', 'DD.MON.YYYY'))
AND ((DATE '1971-12-31' + pickslip_header.pickslip_date)::DATE <  TO_DATE('18.JAN.2026', 'DD.MON.YYYY'))
AND NOT EXISTS (
    SELECT 1
    FROM wo_part_on_off
    WHERE
        wo_part_on_off.partno = rotables.partno
        AND wo_part_on_off.serialno = rotables.serialno
        AND (DATE '1971-12-31' + wo_part_on_off.created_date)::DATE >= TO_DATE('31.DEC.2024', 'DD.MON.YYYY')
        AND wo_part_on_off.status = 0
)
AND sign.department = 'VJC AMO'
AND pickslip_header.station_to != 'VTE'
AND (pickslip_header.receiver LIKE 'A%' OR pickslip_header.receiver = 'COMP')
ORDER BY rotables.partno, rotables.serialno, pickslip_header.pickslip_date DESC