SELECT 

    wo_header.ac_registr AS "AC_REG", 
    TO_CHAR(DATE '1971-12-31' + wo_header.closing_date, 'DD.MON.YYYY') AS "CLOSED_DATE",

    MAX(CASE WHEN wom_def.name = 'BRAKE_1' THEN wom_item.value_num END) AS "BRAKE_1", 

    MAX(CASE WHEN wom_def.name = 'BRAKE_2' THEN wom_item.value_num END) AS "BRAKE_2", 

    MAX(CASE WHEN wom_def.name = 'BRAKE_3' THEN wom_item.value_num END) AS "BRAKE_3", 

    MAX(CASE WHEN wom_def.name = 'BRAKE_4' THEN wom_item.value_num END) AS "BRAKE_4" 

FROM ( 

    SELECT 

        wo_measurement_itemno_i, 

        wo_measurement_defno_i, 

        value_num, 

        measure_date, 

        created_by, 

        created_date, 

        workstep_linkno_i   

    FROM wo_measurement_item 


) AS wom_item 

JOIN wo_measurement_def AS wom_def ON wom_item.wo_measurement_defno_i = wom_def.wo_measurement_defno_i 

JOIN workstep_link AS wsl ON wom_item.workstep_linkno_i = wsl.workstep_linkno_i 

JOIN wo_header ON wo_header.event_perfno_i = wsl.event_perfno_i 
where wo_header.event_perfno_i = @BRK_MON_WO.WO@

GROUP BY wo_header.ac_registr,wo_header.closing_date