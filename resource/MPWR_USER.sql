SELECT
sign.user_sign as "VJC_ID",
sign.firstname as "NAME",
sign.skill_shop as "SKILL"

FROM
    sign
WHERE
 sign.employee_no_i = @MPWR_ONLINE.ID@
ORDER BY
    CASE sign.skill_shop
        WHEN 'B1' THEN 1
        WHEN 'AB2' THEN 2
        WHEN 'B2' THEN 3
        WHEN 'MECH' THEN 4
        WHEN 'TRAINEE_MECH' THEN 5
        ELSE 6
    END