SELECT
ROW_NUMBER() OVER (ORDER BY
    CASE
        WHEN wo_header.release_station = 'SGN' THEN 1
        WHEN wo_header.release_station = 'HAN' THEN 2
        WHEN wo_header.release_station = 'DAD' THEN 3
        WHEN wo_header.release_station = 'CXR' THEN 4
        WHEN wo_header.release_station = 'HPH' THEN 5
        WHEN wo_header.release_station = 'VCA' THEN 6
        WHEN wo_header.release_station = 'PQC' THEN 7
        ELSE 8
    END) AS "SEQ",
wo_header.ac_registr AS "AC",
wo_part_on_off.event_perfno_i AS "WO",
TO_CHAR(DATE '1971-12-31' + wo_part_on_off.created_date,'DD MON YYYY') AS "CREATE_DATE",
wo_header.release_station AS "STATION",
wo_part_on_off.partno AS "PN_ON",
wo_part_on_off.serialno AS "SN_ON",
wo_part_on_off.partno_off AS "PN_OFF",
wo_part_on_off.serialno_off AS "SN_OFF",
wo_part_on_off.created_by AS "CREATE_BY"
FROM
   wo_part_on_off full
   JOIN wo_header ON wo_part_on_off.event_perfno_i = wo_header.event_perfno_i
WHERE
(DATE '1971-12-31' + wo_part_on_off.created_date) :: date >= TO_DATE('@VAR.START_DATE@', 'DD.MON.YYYY')
AND (DATE '1971-12-31' + wo_part_on_off.created_date) :: date <= TO_DATE('@VAR.END_DATE@', 'DD.MON.YYYY')
AND wo_part_on_off.status = 0
AND wo_part_on_off.created_by not like ('TVJ%')
AND wo_header.ac_registr != 'DUMMY'
ORDER BY
    CASE
        WHEN wo_header.release_station = 'SGN' THEN 1
        WHEN wo_header.release_station = 'HAN' THEN 2
        WHEN wo_header.release_station = 'DAD' THEN 3
        WHEN wo_header.release_station = 'CXR' THEN 4
        WHEN wo_header.release_station = 'HPH' THEN 5
        WHEN wo_header.release_station = 'VCA' THEN 6
        WHEN wo_header.release_station = 'PQC' THEN 7
        ELSE 8
    END,
    "CREATE_DATE"
 