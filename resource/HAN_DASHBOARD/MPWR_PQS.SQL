SELECT 'A' AS "SKILL", COUNT(DISTINCT user_sign) AS "TOTAL"
    FROM sign
    LEFT JOIN staff_pqs_qualification ON sign.employee_no_i = staff_pqs_qualification.employee_no_i
    WHERE
    staff_pqs_qualification.pqs_type_no_i = 1378 --TYPE_LABEL = CAT A
    AND sign.department = 'VJC AMO'
    AND sign.status = 0
    AND sign.workgroup IN ( 
                        SELECT
                            vendor
                        FROM address
                        WHERE
                                  address_i =  29878 --AMO HAN TEAM 2
                    )

UNION ALL
    SELECT 'B1' AS "SKILL", COUNT(DISTINCT user_sign) AS "TOTAL"
    FROM sign
    LEFT JOIN staff_pqs_qualification ON sign.employee_no_i = staff_pqs_qualification.employee_no_i
    WHERE
    staff_pqs_qualification.pqs_type_no_i = 1379 --TYPE_LABEL = CAT B1
    AND sign.department = 'VJC AMO'
    AND sign.status = 0
    AND sign.workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                                  address_i =  29878 --AMO HAN TEAM 2
                    )
UNION ALL
    SELECT 'B2' AS "SKILL", COUNT(DISTINCT user_sign) AS "TOTAL"
    FROM sign   
    LEFT JOIN staff_pqs_qualification ON sign.employee_no_i = staff_pqs_qualification.employee_no_i
    WHERE
    staff_pqs_qualification.pqs_type_no_i IN (1380,2771) --TYPE_LABEL = CAT B2
    AND sign.department = 'VJC AMO'
    AND sign.status = 0
    AND sign.workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                                  address_i = 29878 --AMO HAN TEAM 2
                    )
UNION ALL
    SELECT 'MECH' AS "SKILL", COUNT(DISTINCT user_sign) AS "TOTAL"
    FROM sign
    WHERE   
    sign.department = 'VJC AMO'
    AND sign.skill_shop = 'MECH'
    AND sign.status = 0
    AND sign.workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                                  address_i = 29878 --AMO HAN TEAM 2
                    )
UNION ALL
    SELECT 'TRAINEE' AS "SKILL", COUNT(DISTINCT user_sign) AS "TOTAL"
    FROM sign
    WHERE   
    sign.department = 'VJC AMO' 
    AND sign.skill_shop = 'TRAINEE_MECH'
    AND sign.status = 0
    AND sign.workgroup IN (
                        SELECT
                            vendor
                        FROM address
                        WHERE
                                  address_i = 29878 --AMO HAN TEAM 2
                    )