SELECT 
 wo_header.ac_registr AS "AC_REG",
 wo_measurement_def.measure_unit,
 wo_measurement_item.value_num,
 TO_CHAR(DATE '1971-12-31' + wo_measurement_item.measure_date, 'DD.MON.YYYY') AS "DATE"
FROM wo_measurement_def
   LEFT JOIN wo_measurement_item ON wo_measurement_def.wo_measurement_defno_i = wo_measurement_item.wo_measurement_defno_i
    LEFT JOIN workstep_link ON wo_measurement_item.workstep_linkno_i = workstep_link.workstep_linkno_i
    LEFT JOIN wo_header ON wo_header.event_perfno_i = workstep_link.event_perfno_i
WHERE wo_measurement_def.name IN ('OXYGEN PRESSURE','OXYGEN PRESSURE 1','OXYGEN PRESSURE 2')
    AND wo_measurement_def.mutation BETWEEN 19527 AND 19534