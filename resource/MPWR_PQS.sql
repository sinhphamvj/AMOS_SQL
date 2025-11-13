SELECT
spq.ac_type,
spq.limitation as "RATING",
spq.scope AS "SCOPE",
spq.notes AS "NOTES",
spq.special_text_1 as "LIMITATION"

FROM
    staff_pqs_qualification spq
WHERE
   spq.pqs_type_no_i IN ( 1378,1379,1380,2771) and
 spq.employee_no_i = @MPWR_ONLINE.ID@
and (DATE '1971-12-31'+spq.expiry_date) >= TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')