SELECT 
    COUNT(user_sign) AS "TOTAL_RESOURCE"
FROM 
    sign
WHERE 
    department = 'VJC AMO'
    AND status = 0
    AND
    ((
    workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            parent IN (29868,29869))
    ) OR workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            address_i IN (29868,29869)
    ))