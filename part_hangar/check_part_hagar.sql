SELECT 
rotables.locationno_i,
rotables.partno as "PN",
rotables.serialno AS "SN",
pickslip_header.pickslipno,
TO_CHAR(DATE '1971-12-31' + pickslip_header.pickslip_date, 'DD.MON.YYYY') AS "ISSUE_DATE",
pickslip_header.mech_sign,
pickslip_header.station_to,
pickslip_header.receiver,
pickslip_header.event_type,
pickslip_header.event_key,
(
          SELECT COALESCE (
                    (
                       SELECT DISTINCT workstep_link.event_perfno_i
                       FROM part_request_2
                       JOIN workstep_link ON part_request_2.event_key = workstep_link.workstep_linkno_i AND (part_request_2.event_type = 'WSL')
                       LEFT JOIN wo_header ON workstep_link.event_perfno_i = wo_header.event_perfno_i AND (wo_header.workorderno_display IS NOT NULL)
                       WHERE pickslip_detail.part_requestno_i = part_request_2.part_requestno_i
                    ),
                    (
                       SELECT event_pending.workorderno
                       FROM part_request_2 pr
                       JOIN event_pending ON pr.event_key = event_pending.pendingno_i AND (pr.event_type = 'GENEVENT')
                       WHERE pickslip_detail.part_requestno_i = pr.part_requestno_i
                    )
                 )
) as "WORKORDER_NO",
pickslip_header.remarks,
pickslip_header.pickslip_text,
pickslip_booked.status AS "BOOKED_STATUS",
pickslip_booked.location_from as "LOCATION_FROM",
pickslip_booked.location_to as "LOCATION_TO"
FROM
rotables
LEFT JOIN pickslip_booked ON rotables.partno = pickslip_booked.partno AND rotables.serialno = pickslip_booked.serialno
LEFT JOIN part ON rotables.partno = part.partno AND part.mat_class = 'R'
JOIN pickslip_header ON pickslip_header.pickslipno = pickslip_booked.pickslipno
JOIN pickslip_detail ON pickslip_header.pickslipno = pickslip_detail.pickslipno
LEFT JOIN sign ON pickslip_header.mech_sign = sign.user_sign
WHERE
rotables.location = 'HANGAR'
AND pickslip_booked.status = 9
AND pickslip_booked.location_to <> 'TRANSFER'
AND pickslip_header.pickslip_date >= 19630
AND ((DATE '1971-12-31' + pickslip_header.pickslip_date) :: date < current_timestamp :: date)
AND NOT EXISTS (
    SELECT 1
    FROM wo_part_on_off
    WHERE
        wo_part_on_off.partno = rotables.partno
        AND wo_part_on_off.serialno = rotables.serialno
        AND wo_part_on_off.created_date >= 19630
        AND wo_part_on_off.status = 0
)
AND sign.department = 'VJC AMO'
AND pickslip_header.station_to != 'VTE'
AND (pickslip_header.receiver LIKE 'A%' OR pickslip_header.receiver = 'COMP')
AND pickslip_header.receiver NOT IN (
    SELECT 
            mdr.ac_registr
    FROM moc_daily_records mdr
    WHERE mdr.event_type IN ( 'A_CHK', 'C_CHK')
    AND mdr.closed <> 'Y' 
    AND ((mdr.occurance_date * 24 * 60) + mdr.occurance_time) <= 
      (((CURRENT_DATE - DATE '1971-12-31') * 24 * 60) + (EXTRACT(HOUR FROM CURRENT_TIME) * 60 + EXTRACT(MINUTE FROM CURRENT_TIME)))
)