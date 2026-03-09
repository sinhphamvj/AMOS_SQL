SELECT 
    s.firstname,
    s.lastname,
    s.sex,
    TO_CHAR((DATE '1971-12-31' + s.birthdate)::DATE, 'DD/MM/YYYY') AS birthdate,
    s.nationality,
    s.street,
    s.city,
    s.country,
    MAX(CASE WHEN rpv.property_type_no_i = 2086 THEN rpv.char_value END) AS place_of_birth,
    MAX(CASE WHEN rpv.property_type_no_i = 2087 THEN rpv.char_value END) AS country_of_birth,
    MAX(CASE WHEN rpv.property_type_no_i = 2093 THEN rpv.char_value END) AS ethnic,
    MAX(CASE WHEN rpv.property_type_no_i = 2094 THEN rpv.char_value END) AS religion,
    MAX(CASE WHEN rpv.property_type_no_i = 2098 THEN rpv.char_value END) AS passport_no,
    MAX(CASE WHEN rpv.property_type_no_i = 2092 THEN rpv.char_value END) AS homeland,
    MAX(CASE WHEN rpv.property_type_no_i = 178 THEN rpv.char_value END) AS phoneno,
    MAX(CASE WHEN rpv.property_type_no_i = 2181 THEN rpv.char_value END) AS place_of_residence,
    MAX(CASE WHEN rpv.property_type_no_i = 2182 THEN rpv.char_value END) AS current_address,
    TO_CHAR(DATE '1971-12-31' + MAX(CASE WHEN rpv.property_type_no_i = 2099 THEN rpv.int_value END)::INTEGER,'DD/MM/YYYY') AS passport_issued_date,
    MAX(CASE WHEN rpv.property_type_no_i = 2100 THEN rpv.char_value END) AS passport_issued_place,
    MAX(CASE WHEN rpv.property_type_no_i = 2101 THEN rpv.char_value END) AS education,
    TO_CHAR(DATE '1971-12-31' + MAX(CASE WHEN rpv.property_type_no_i = 2102 THEN rpv.int_value END)::INTEGER,'DD/MM/YYYY') AS ket_nap_dang_date
FROM sign s
LEFT JOIN rm_property_value rpv 
    ON s.employee_no_i = rpv.owner_amos_key
    AND rpv.owner_amos_type = 'SG'
WHERE
s.user_sign='@VAR.VJCID@'
GROUP BY s.employee_no_i, s.firstname, s.lastname, s.sex, 
         s.birthdate, s.nationality, s.street, s.city, s.country
