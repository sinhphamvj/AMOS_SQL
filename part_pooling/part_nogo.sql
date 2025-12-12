SELECT
part_special.part_specialno_i,
part_special.partno as "PN",
part.description as "DESC",
part_special.special as "SPECIAL",
part.ata_chapter as "ATA",
part.measure_unit as "MU",
part_special.amount,
rp.total_rotable_value as "STOCK_AVAIL",
rp.sgn_stock as "SGN",
rp.han_stock as "HAN",
rp.dad_stock as "DAD",
rp.cxr_stock as "CXR",
rp.vii_stock as "VII",
rp.vca_stock as "VCA",
rp.hph_stock as "HPH",
rp.pqc_stock as "PQC"
FROM part_special
JOIN part ON part.partno = part_special.partno
LEFT JOIN (
    SELECT partno,
           SUM(custom_value) AS total_rotable_value,
           SUM(CASE WHEN station = 'SGN' THEN custom_value ELSE 0 END) AS sgn_stock,
           SUM(CASE WHEN station = 'HAN' THEN custom_value ELSE 0 END) AS han_stock,
           SUM(CASE WHEN station = 'DAD' THEN custom_value ELSE 0 END) AS dad_stock,
           SUM(CASE WHEN station = 'CXR' THEN custom_value ELSE 0 END) AS cxr_stock,
           SUM(CASE WHEN station = 'VII' THEN custom_value ELSE 0 END) AS vii_stock,
           SUM(CASE WHEN station = 'VCA' THEN custom_value ELSE 0 END) AS vca_stock,
           SUM(CASE WHEN station = 'HPH' THEN custom_value ELSE 0 END) AS hph_stock,
           SUM(CASE WHEN station = 'PQC' THEN custom_value ELSE 0 END) AS pqc_stock
    FROM (
        SELECT part_location.partno,
               0.0 AS custom_value,
               location.station
        FROM part_location
        JOIN location ON part_location.locationno_i = location.locationno_i
        WHERE location.station <> 'BKK'
              AND location.location_type <> -107
              AND location.location_restriction = 0
        UNION ALL
        SELECT rotables.partno,
               1.0 AS custom_value,
               location.station
        FROM rotables
        JOIN location ON rotables.locationno_i = location.locationno_i
        WHERE rotables.ac_registr IN ('', 'TRANSF')
              AND rotables.condition <> 'US'
              AND location.station <> 'BKK'
              AND location.location_type <> -107
              AND location.location_restriction = 0
              AND rotables.partnonew = ''
    ) AS combined
    GROUP BY partno
) rp ON part.partno = rp.partno
WHERE 
part_special.special = 'NOGO'
AND part.mat_class = 'R'