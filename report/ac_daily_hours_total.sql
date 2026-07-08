SELECT
    acu.ac_registr AS "AC",
    TO_CHAR(DATE '1971-12-31' + MIN(acu.departure_date), 'DD.MON.YYYY')
        || ' - '
        || TO_CHAR(DATE '1971-12-31' + MAX(acu.departure_date), 'DD.MON.YYYY') AS "FROM_TO",
    LPAD(FLOOR(SUM(acu.daily_hours) / 60)::TEXT, 2, '0')
        || ':'
        || LPAD(MOD(SUM(acu.daily_hours)::INT, 60)::TEXT, 2, '0') AS "TOTAL"
FROM ac_utilization acu
JOIN aircraft ac ON ac.ac_registr = acu.ac_registr
    AND ac.operator = 'VJC'
    AND ac.non_managed = 'N'
    AND ac.status = 0
WHERE (DATE '1971-12-31' + acu.departure_date)::DATE >= TO_DATE('@VAR.FROM_DATE@', 'DD.MON.YYYY')
  AND (DATE '1971-12-31' + acu.departure_date)::DATE <= TO_DATE('@VAR.TO_DATE@', 'DD.MON.YYYY')
  AND acu.status = 0
GROUP BY acu.ac_registr
ORDER BY acu.ac_registr
