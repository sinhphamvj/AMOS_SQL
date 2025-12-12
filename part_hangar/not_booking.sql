SELECT
ROW_NUMBER() OVER (ORDER BY
    CASE
        WHEN sign.homebase = 'SGN' THEN 1
        WHEN sign.homebase = 'HAN' THEN 2
        WHEN sign.homebase = 'DAD' THEN 3
        WHEN sign.homebase = 'CXR' THEN 4
        WHEN sign.homebase = 'HPH' THEN 5
        WHEN sign.homebase = 'VCA' THEN 6
        WHEN sign.homebase = 'PQC' THEN 7
        ELSE 8
    END, wo_part_on_off.created_date) AS "SEQ",
wo_header.ac_registr AS "AC",
wo_part_on_off.event_perfno_i AS "WO",
TO_CHAR(DATE '1971-12-31' + wo_part_on_off.created_date,'DD MON YYYY') AS "CREATE_DATE",
sign.homebase AS "STATION",
wo_part_on_off.partno AS "PN_ON",
wo_part_on_off.serialno AS "SN_ON",
wo_part_on_off.partno_off AS "PN_OFF",
wo_part_on_off.serialno_off AS "SN_OFF",
wo_text_action.sign_performed AS "CREATE_BY"
FROM
   wo_part_on_off full
   JOIN wo_header ON wo_part_on_off.event_perfno_i = wo_header.event_perfno_i
   LEFT JOIN wo_text_action ON wo_part_on_off.actionno_i = wo_text_action.actionno_i
   LEFT JOIN sign ON wo_text_action.sign_performed = sign.user_sign
WHERE
(DATE '1971-12-31' + wo_part_on_off.created_date) :: date >= TO_DATE('@VAR.START_DATE@', 'DD.MON.YYYY')
AND (DATE '1971-12-31' + wo_part_on_off.created_date) :: date <= TO_DATE('@VAR.END_DATE@', 'DD.MON.YYYY')
AND wo_part_on_off.status = 0
AND wo_text_action.sign_performed not like ('TVJ%')
AND wo_header.ac_registr != 'DUMMY'