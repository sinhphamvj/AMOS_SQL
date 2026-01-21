SELECT
part_special.part_specialno_i,
part_special.partno as "PN",
part.description as "DESC",
part_special.special as "SPECIAL",
part.ata_chapter as "ATA",
part.measure_unit as "MU",
COALESCE(spa_view.qty_sgn, 0) as "IDEAL_QTY_SGN",
COALESCE(spa_view.qty_han, 0) as "IDEAL_QTY_HAN",
COALESCE(spa_view.qty_dad, 0) as "IDEAL_QTY_DAD",
COALESCE(spa_view.qty_cxr, 0) as "IDEAL_QTY_CXR",
(COALESCE(spa_view.qty_sgn, 0) + COALESCE(spa_view.qty_han, 0) + COALESCE(spa_view.qty_dad, 0) + COALESCE(spa_view.qty_cxr, 0)) as "TOTAL_QTY"
FROM part_special
LEFT JOIN part ON part.partno = part_special.partno
LEFT JOIN (
    SELECT 
        partno,
        MAX(CASE WHEN spa_listno_i = 1334 THEN ideal_qty END) as qty_sgn,
        MAX(CASE WHEN spa_listno_i = 1335 THEN ideal_qty END) as qty_han,
        MAX(CASE WHEN spa_listno_i = 1336 THEN ideal_qty END) as qty_dad,
        MAX(CASE WHEN spa_listno_i = 1337 THEN ideal_qty END) as qty_cxr
    FROM spa_detail
    WHERE spa_listno_i IN (1334, 1335, 1336, 1337)
    GROUP BY partno
) spa_view ON spa_view.partno = part.partno
WHERE 
part_special.special = 'NOGO'
AND part.mat_class = 'R'
