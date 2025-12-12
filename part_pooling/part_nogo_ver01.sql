SELECT
part.partno as "PN",
part.description as "DESC",
part.ata_chapter as "ATA",
part.measure_unit as "MU",
spa_detail.reorder_level as "MIN_REQUIRE",
spa_header.name ,
spa_header.station
FROM part
JOIN spa_detail on spa_detail.partno = part.partno
JOIN spa_header ON spa_header.listno_i = spa_detail.spa_listno_i
WHERE 
spa_header.name = 'NOGO_L_SGN'