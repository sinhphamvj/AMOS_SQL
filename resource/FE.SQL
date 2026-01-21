SELECT
    s.employee_no_i AS "ID",
    s.user_sign as "VJC_ID",
    s.firstname as "NAME",
    s.skill_shop as "SKILL",
    STRING_AGG(DISTINCT spq.limitation, ', ') as "RATING",
    STRING_AGG(DISTINCT spq.scope, ', ') AS "SCOPE"
FROM
    sign s
JOIN
    sp_user_availability sua ON s.user_sign = sua.user_sign
LEFT JOIN
    staff_pqs_qualification spq ON s.employee_no_i = spq.employee_no_i AND spq.pqs_type_no_i IN ( 1378,1379,1380,2771)
LEFT JOIN 
    sp_day_entry_type on sua.entry_type = sp_day_entry_type.type_id
WHERE
    sp_day_entry_type.short_code = '@REQ_FE.SHORT_CODE@'
    AND (DATE '1971-12-31' + sua.start_date )::DATE = TO_DATE('@REQ_FE.DATE_REQ@','YYYY-MM-DD')
GROUP BY
    s.employee_no_i,
    s.user_sign,
    s.firstname,
    s.skill_shop