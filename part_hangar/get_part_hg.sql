SELECT rotables.partno,
       location.station,
       location.store,
       location.location,
       rotables.serialno,
       CASE WHEN (
          SELECT inspection_detail.status
          FROM inspection_detail
          WHERE inspection_detail.inspection_detailno_i = (
                   SELECT MAX (inspection_detail.inspection_detailno_i)
                   FROM inspection_detail
                   WHERE inspection_detail.ref_type = 'RO'
                         AND inspection_detail.ref_key = rotables.psn
                )
       ) = 1
       OR (
          SELECT R2.rotable_status
          FROM rotables R2
          WHERE R2.psn = rotables.psn
                AND R2.condition <> 'US'
       ) = 2 THEN 'Y' ELSE 'N' END,
       rotables.labelno,
       
       contract_data.contract_code,
       (
          SELECT part.special_measure_unit
          FROM part
          WHERE part.partno = rotables.partno
       ),
       rotables.pma,
       rotables.owner,
       rotables.condition,
       entity_header.entity_code,
       '',
       COALESCE (
          od_header.orderno,
          rotables.orderno
       ),
       (
          SELECT MAX (MAX1.vendor)
          FROM od_header MAX1
          WHERE MAX1.orderno = COALESCE (
                   od_header.orderno,
                   rotables.orderno
                )
       ),
       '1',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'N',
       (
          SELECT 1
          FROM part_special
          WHERE part_special.partno = rotables.partno
                AND part_special.special = 'KIT'
       ),
       rotables.is_managed,
       rotables.shelf_inspection_date,
       (
          SELECT requirement_type.description
          FROM requirement_type
          WHERE requirement_type.requirement = rotables.shelf_inspection_type
       ),
       rotables.shelf_inspection_type,
       location.location_restriction,
       location.location_type,
       rotables.psn,
       rotables.locationno_i,
       (
          SELECT COALESCE (
                    COUNT (*),
                    0
                 )
          FROM wo_header
          WHERE rotables.psn = wo_header.psn
                AND wo_header.state = 'O'
                AND wo_header.type IN (
                   'S',
                   'C',
                   'M',
                   'P'
                )
                AND wo_header.workorderno_display IS NOT NULL
       ),
       rotables.projectno_i,
       (
          SELECT (
                    MAX (rotables_weight_history.weight)
                 )
          FROM rotables_weight_history
          WHERE rotables_weight_history.psn = rotables.psn
                AND rotables_weight_history.del_date = (
                   SELECT (
                             MAX (rotables_weight_history.del_date)
                          )
                   FROM rotables_weight_history
                   WHERE rotables_weight_history.psn = rotables.psn
                )
                AND rotables_weight_history.recno = (
                   SELECT (
                             MAX (RW2.recno)
                          )
                   FROM rotables_weight_history RW2
                   WHERE RW2.psn = rotables_weight_history.psn
                         AND RW2.del_date = rotables_weight_history.del_date
                )
       ),
       (
          SELECT MAX (MAX2.status)
          FROM od_header MAX2
          WHERE MAX2.orderno = COALESCE (
                   od_header.orderno,
                   rotables.orderno
                )
       ),
       rotables.rec_detailno_i,
       rotables.purch_recdetailno_i,
       entity_header.entityno_i,
       rotables.linked_contract
FROM rotables
JOIN location ON rotables.locationno_i = location.locationno_i
JOIN entity_header ON rotables.entityno_i = entity_header.entityno_i
LEFT JOIN contract_data ON rotables.linked_contract = contract_data.contract_id
LEFT JOIN od_detail ON rotables.material_lifecycle_id = od_detail.material_lifecycle_id AND (od_detail.state = 'O')
LEFT JOIN od_header ON od_header.orderno_i = od_detail.orderno_i
WHERE rotables.partno = 'S6-01-0005-320'
      AND rotables.ac_registr IN (
         '',
         'TRANSF'
      )
      AND NOT EXISTS (
         SELECT rotables_tree.rotables_treeno_i
         FROM rotables_tree
         WHERE rotables_tree.rotables_treeno_i = rotables.psn
               AND rotables_tree.left_key > 1
      )
      AND rotables.condition <> 'US'
      AND rotables.locationno_i <> -200
      AND location.station = 'SGN'
      AND location.location_type <> -3
      AND location.location_type <> -107  
