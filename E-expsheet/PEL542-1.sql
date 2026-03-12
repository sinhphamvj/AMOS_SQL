SELECT 
    s.firstname,
    s.lastname,
    MAX(CASE WHEN rpv.property_type_no_i = 2181 THEN rpv.char_value END) AS place_of_residence,
    s.sex,
    TO_CHAR((DATE '1971-12-31' + s.birthdate)::DATE, 'DD.MON.YYYY') AS birthdate,
    MAX(CASE WHEN rpv.property_type_no_i = 178 THEN rpv.char_value END) AS phoneno,
    s.city,
    MAX(CASE WHEN rpv.property_type_no_i = 2086 THEN rpv.char_value END) AS place_of_birth,
    s.nationality AS nationality_code,
    cn.description AS nationality,
    s.email,
    s.mech_stamp,
    s.country AS country_code,
    cc.description AS country,
    TO_CHAR((DATE '1971-12-31' + s.license_issue_date)::DATE, 'DD.MON.YYYY') AS license_issued_date,
    s.skill_shop,
    MAX(CASE WHEN rpv.property_type_no_i = 2090 THEN rpv.char_value END) AS hair,
    MAX(CASE WHEN rpv.property_type_no_i = 2091 THEN rpv.char_value END) AS eyes,
    TO_CHAR(MAX(CASE WHEN rpv.property_type_no_i = 2089 THEN rpv.double_value END), 'FM999') AS uweight,
    TO_CHAR(MAX(CASE WHEN rpv.property_type_no_i = 2088 THEN rpv.int_value END), 'FM999') AS uheight
FROM sign s
LEFT JOIN rm_property_value rpv 
    ON s.employee_no_i = rpv.owner_amos_key
    AND rpv.owner_amos_type = 'SG'
LEFT JOIN country cn
    ON cn.country = s.nationality
LEFT JOIN country cc
    ON cc.country = s.country
WHERE
    s.user_sign='VJC2741'
GROUP BY s.employee_no_i, s.firstname, s.lastname, s.sex, s.birthdate,
         s.city, s.nationality, cn.description, s.email, s.mech_stamp,
         s.country, cc.description, s.license_issue_date, s.skill_shop
