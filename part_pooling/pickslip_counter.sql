SELECT 
    -- Tổng số pickslip
    MAX(CASE WHEN "PICKSLIP" = 'ISSUED' THEN "PLS_COUNT" ELSE 0 END) AS "ISSUED_TOTAL",
    --Tổng số pickslip
    MAX(CASE WHEN "PICKSLIP" = 'DELETE' THEN "PLS_COUNT" ELSE 0 END) AS "DELETE_TOTAL",
    --Tổng số pickslip
    MAX(CASE WHEN "PICKSLIP" = 'CLOSED' THEN "PLS_COUNT" ELSE 0 END) AS "CLOSED_TOTAL",
    -- Tổng số pickslip Total
    SUM("PLS_COUNT")::INTEGER AS "TOTAL_PLS"
FROM (  
    -- Query tổng số pickslip ISSUED
    SELECT COUNT(DISTINCT(pickslip_header.pickslipno)) AS "PLS_COUNT", 'ISSUED' AS "PICKSLIP"
    FROM pickslip_header
    WHERE 
    pickslip_header.status IN (0,1,6) AND
    (DATE '1971-12-31' + pickslip_header.created_date)::DATE =  TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')

    UNION ALL
    -- Query tổng số pickslip DELÊT
    SELECT COUNT(DISTINCT(pickslip_header.pickslipno)) AS "PLS_COUNT", 'DELETE' AS "PICKSLIP"
    FROM pickslip_header
    WHERE 
    pickslip_header.status IN (10,8)
    AND (DATE '1971-12-31' + pickslip_header.created_date)::DATE =  TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')

    UNION ALL
    -- Query tổng số pickslip CLOSED
    SELECT COUNT(DISTINCT(pickslip_header.pickslipno)) AS "PLS_COUNT", 'CLOSED' AS "PICKSLIP"
    FROM pickslip_header
    WHERE 
    pickslip_header.status IN (9,7)
    AND (DATE '1971-12-31' + pickslip_header.created_date)::DATE =  TO_DATE('@VAR.DATE@', 'DD.MON.YYYY')
) AS pickslip_count