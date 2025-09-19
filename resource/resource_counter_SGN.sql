SELECT
    total."TOTAL_RESOURCE",
    online."ONLINE_COUNT"
FROM
    (
        SELECT
            COUNT(user_sign) AS "TOTAL_RESOURCE"
        FROM
            sign
        WHERE
            department = 'VJC AMO'
            AND status = 0
            AND workgroup IN (
                SELECT
                    vendor
                FROM address
                WHERE
                    parent IN (29760, 29748) OR address_i = 29760
            )
    ) AS total,
    (
        SELECT
            COUNT(*) AS "ONLINE_COUNT"
        FROM
            sp_user_availability
        WHERE
            (
                DATE '1971-12-31' + start_date + CASE
                    WHEN start_time + 420 >= 1440 THEN 1
                    ELSE 0
                END
            )::DATE = (current_timestamp + INTERVAL '7 hours')::DATE
            AND (
                (
                    (current_timestamp + INTERVAL '7 hours')::time BETWEEN '05:00:00' AND '17:00:00'
                    AND entry_type IN ('B1', 'B11', 'B12', 'B16', 'B20', 'B3', 'B5', 'B7')
                ) OR (
                    (current_timestamp + INTERVAL '7 hours')::time NOT BETWEEN '05:00:00' AND '17:00:00'
                    AND entry_type IN ('B10', 'B13', 'B19', 'B2', 'B22', 'B4', 'B6', 'B8', 'E')
                )
            )
    ) AS online