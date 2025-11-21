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
            parent = 29866)
    ) OR workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            parent = 29867
    )OR workgroup IN (
        SELECT 
            vendor
        FROM address
        WHERE 
            address_i = 29866
    ))