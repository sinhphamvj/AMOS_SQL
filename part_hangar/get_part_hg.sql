SELECT 
    base.station AS "STATION",
    MAX(CASE WHEN task_counts."TYPE" = 'PART_HANGAR' THEN task_counts."COUNT" ELSE 0 END) AS "PART_HANGAR_COUNT"
FROM (
    SELECT 'SGN' AS station UNION ALL SELECT 'HAN' UNION ALL SELECT 'DAD' UNION ALL 
    SELECT 'CXR' UNION ALL SELECT 'PQC' UNION ALL SELECT 'VCA' UNION ALL 
    SELECT 'VII' UNION ALL SELECT 'HPH' UNION ALL SELECT 'VTE'
) AS base
LEFT JOIN (
    SELECT 
        t.station,
        COUNT(*) AS "COUNT",
        'PART_HANGAR' AS "TYPE"
    FROM (
        SELECT DISTINCT ON (rotables.partno, rotables.serialno)
            pickslip_header.station_to AS station
        FROM rotables
        LEFT JOIN pickslip_booked ON rotables.partno = pickslip_booked.partno AND rotables.serialno = pickslip_booked.serialno
        LEFT JOIN pickslip_header ON pickslip_header.pickslipno = pickslip_booked.pickslipno
        LEFT JOIN sign ON pickslip_header.mech_sign = sign.user_sign
        WHERE
            rotables.location = 'HANGAR'
            AND pickslip_booked.status = 9
            AND pickslip_booked.location_to <> 'TRANSFER'
            AND (DATE '1971-12-31' + pickslip_header.pickslip_date)::DATE BETWEEN TO_DATE('@VAR.START_DATE@', 'DD.MON.YYYY') AND TO_DATE('@VAR.END_DATE@', 'DD.MON.YYYY')
            AND NOT EXISTS (
                SELECT 1
                FROM wo_part_on_off
                WHERE
                    wo_part_on_off.partno = rotables.partno
                    AND wo_part_on_off.serialno = rotables.serialno
                    AND (DATE '1971-12-31' + wo_part_on_off.created_date)::DATE >= TO_DATE('@VAR.START_DATE@', 'DD.MON.YYYY')
                    AND wo_part_on_off.status = 0
            )
            AND sign.department = 'VJC AMO'
            AND (EXISTS (
                     SELECT aircraft.ac_registr
                     FROM aircraft
                     WHERE pickslip_header.receiver = aircraft.ac_registr
                           AND aircraft.ac_registr LIKE 'A%'
                           AND aircraft.operator = 'VJC'
                           AND aircraft.non_managed = 'N'
            ) OR pickslip_header.receiver = 'COMP')
        ORDER BY rotables.partno, rotables.serialno, pickslip_header.pickslip_date DESC
    ) t
    GROUP BY t.station
) AS task_counts ON base.station = task_counts.station
GROUP BY base.station
ORDER BY 
    CASE
        WHEN base.station = 'SGN' THEN 1
        WHEN base.station = 'HAN' THEN 2
        WHEN base.station = 'DAD' THEN 3
        WHEN base.station = 'CXR' THEN 4
        WHEN base.station = 'HPH' THEN 5
        WHEN base.station = 'PQC' THEN 6
        WHEN base.station = 'VCA' THEN 7
        WHEN base.station = 'VII' THEN 8
        WHEN base.station = 'VTE' THEN 9
        ELSE 10
    END;
