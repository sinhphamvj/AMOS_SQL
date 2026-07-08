WITH target_wo AS (
    SELECT DISTINCT ON (wo_header.ac_registr)
           wo_header.event_perfno_i AS "WO"
    FROM wo_header
    JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
    JOIN workstep_link AS wsl ON wo_header.event_perfno_i = wsl.event_perfno_i 
    JOIN wo_measurement_item ON wo_measurement_item.workstep_linkno_i = wsl.workstep_linkno_i 
    WHERE event_template.wtno_i IN (280832, 280413, 281041)
      AND wo_header.event_type = 'JC'
      AND wo_header.state = 'C'
      AND wo_header.event_perfno_i > 0
      AND (DATE '1971-12-31' + wo_header.closing_date) :: date >= (current_timestamp - interval '16 day') :: date
    ORDER BY wo_header.ac_registr, wo_header.event_perfno_i DESC
)
SELECT 
    b."AC_REG", 
    b."CLOSED_DATE",
    b."BRAKE_1", 
    b."BRAKE_2", 
    b."BRAKE_3", 
    b."BRAKE_4",
    CASE 
        WHEN b."BRAKE_1" <= 2.0 OR b."BRAKE_2" <= 2.0 OR b."BRAKE_3" <= 2.0 OR b."BRAKE_4" <= 2.0 THEN 1
        WHEN (b."BRAKE_1" > 2.0 AND b."BRAKE_1" <= 5.0) OR 
             (b."BRAKE_2" > 2.0 AND b."BRAKE_2" <= 5.0) OR 
             (b."BRAKE_3" > 2.0 AND b."BRAKE_3" <= 5.0) OR 
             (b."BRAKE_4" > 2.0 AND b."BRAKE_4" <= 5.0) THEN 2
        ELSE 3
    END AS "PRI"
FROM (
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
    JOIN target_wo ON wo_header.event_perfno_i = target_wo."WO"
    GROUP BY wo_header.ac_registr, wo_header.closing_date
) b
ORDER BY "PRI" ASC