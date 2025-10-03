SELECT
spq.ac_type,
spq.limitation as "RATING",
spq.scope AS "SCOPE",
spq.notes AS "NOTES"

FROM
    staff_pqs_qualification spq
WHERE
   spq.pqs_type_no_i IN ( 1378,1379,1380,2771) and
 spq.employee_no_i = @MPWR_ONLINE.ID@