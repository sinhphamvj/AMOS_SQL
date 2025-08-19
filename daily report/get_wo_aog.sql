-- GET AOG DATA --- DLYRP = AOG , WO.STATE = OPEN ,
SELECT
    wh.event_perfno_i,
    wh.ac_registr,
    wh.issue_station,
    TO_CHAR(
        DATE '1971-12-31' + wh.created_date,
        'DD MON YYYY'
    ),
    wtd.header,
    wtd.text,
    dl.description,
    dl.source_pk,
    dl.ref_type
FROM
    wo_header wh
    INNER JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
    INNER JOIN wo_text_description wtd ON wl.descno_i = wtd.descno_i
    INNER JOIN db_link dl ON CAST(wh.event_perfno_i AS VARCHAR(40)) = dl.source_pk
WHERE
    wh.ac_registr LIKE 'A%'
    AND dl.ref_type = 'DLYRP'
    AND dl.description = 'AOG'
    AND wh.state = 'O' -- VER 2 get AOG data with 4 table
SELECT
    dl.ref_type AS "Daily Report",
    dl.description AS "Daily Report Type",
    wh.event_perfno_i AS "WO",
    wh.ac_registr AS "AC REG",
    wh.issue_station AS "STATION",
    TO_CHAR(
        DATE '1971-12-31' + wh.created_date,
        'DD.MON.YYYY'
    ) AS "ISSUE DATE",
    TO_CHAR(
        DATE '1971-12-31' + wt.absolute_due_date,
        'DD.MON.YYYY'
    ) AS "ESTIMATED SERVICE DATE",
    wtd.header AS "DEFECT",
    wtd.text AS "ACTION TAKEN",
    dl.link_remarks AS "REMARKS"
FROM
    wo_header wh
    INNER JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
    INNER JOIN wo_text_description wtd ON wl.descno_i = wtd.descno_i
    INNER JOIN db_link dl ON CAST(wh.event_perfno_i AS VARCHAR(40)) = dl.source_pk
    INNER JOIN wo_transfer wt ON wh.event_perfno_i = wt.event_perfno_i
WHERE
    wh.ac_registr LIKE 'A%'
    AND dl.ref_type = 'DLYRP'
    AND dl.description = 'AOG'
    AND wh.state = 'O';

-- GET SCHEDULE DATA --- DLYRP = SCHEDULE CHECK , WO.STATE = OPEN , FROM, TO
SELECT
    dl.ref_type AS "Daily Report",
    dl.description AS "Daily Report Type",
    wh.event_perfno_i AS "WO",
    wh.ac_registr AS "AC REG",
    wh.issue_station AS "STATION",
    TO_CHAR(
        DATE '1971-12-31' + wh.created_date,
        'DD.MON.YYYY'
    ) AS "CREATED DATE",
    TO_CHAR(
        DATE '1971-12-31' + wh.issue_date,
        'DD.MON.YYYY'
    ) AS "ISSUE DATE",
    TO_CHAR(
        DATE '1971-12-31' + wt.absolute_due_date,
        'DD.MON.YYYY'
    ) AS "ESTIMATED SERVICE DATE",
    wtd.header AS "DEFECT",
    wtd.text AS "ACTION TAKEN",
    dl.link_remarks AS "REMARKS",
    dl2_from.description AS "FROM",
    dl2_to.description AS "TO"
FROM
    wo_header wh
    INNER JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
    INNER JOIN wo_text_description wtd ON wl.descno_i = wtd.descno_i
    INNER JOIN db_link dl ON CAST(wh.event_perfno_i AS VARCHAR(40)) = dl.source_pk
    INNER JOIN wo_transfer wt ON wh.event_perfno_i = wt.event_perfno_i
    LEFT JOIN db_link dl2_from ON dl.source_pk = dl2_from.source_pk
    AND dl2_from.ref_type = 'FROM'
    LEFT JOIN db_link dl2_to ON dl.source_pk = dl2_to.source_pk
    AND dl2_to.ref_type = 'TO'
WHERE
    wh.ac_registr LIKE 'A%'
    AND dl.ref_type = 'DLYRP'
    AND dl.description = 'SCHEDULE CHECK'
    AND wh.state = 'O'
UNION
SELECT
    NULL AS "Daily Report",
    NULL AS "Daily Report Type",
    NULL AS "WO",
    NULL AS "AC REG",
    NULL AS "STATION",
    NULL AS "CREATED DATE",
    NULL AS "ISSUE DATE",
    NULL AS "ESTIMATED SERVICE DATE",
    NULL AS "DEFECT",
    NULL AS "ACTION TAKEN",
    NULL AS "REMARKS",
    NULL AS "FROM",
    NULL AS "TO"
    /*---- GET DATA WO FOR DLYRP = A330.A321.ACT , HAS DUE_DATE - REV 00
     
     */
SELECT
    dl.ref_type AS "Daily Report",
    dl.description AS "Daily Report Type",
    wh.event_perfno_i AS "WO",
    wh.ac_registr AS "AC REG",
    wh.issue_station AS "STATION",
    TO_CHAR(
        DATE '1971-12-31' + wh.created_date,
        'DD.MON.YYYY'
    ) AS "CREATED DATE",
    TO_CHAR(
        DATE '1971-12-31' + wt.absolute_due_date,
        'DD.MON.YYYY'
    ) AS "ESTIMATED SERVICE DATE",
    wtd.header AS "DEFECT",
    wtd.text AS "ACTION TAKEN",
    dl.link_remarks AS "REMARKS" dl2_due_date.description AS "DUE DATE"
FROM
    wo_header wh
    INNER JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
    INNER JOIN wo_text_description wtd ON wl.descno_i = wtd.descno_i
    INNER JOIN db_link dl ON CAST(wh.event_perfno_i AS VARCHAR(40)) = dl.source_pk
    INNER JOIN wo_transfer wt ON wh.event_perfno_i = wt.event_perfno_i
    LEFT JOIN db_link dl2_due_date ON dl.source_pk = dl2_due_date.source_pk
    AND dl2_due_date.ref_type = 'DUE_DATE'
WHERE
    wh.ac_registr LIKE 'A%'
    AND dl.ref_type = 'DLYRP'
    AND dl.description = 'A330.A321.ACT'
    AND wh.state = 'O';

/*
 Lấy danh sách các WO có DLYRP = "SCHEDULE CHECK" - REV 01
 
 - Lấy thêm col FH và FC
 
 
 */
SELECT
    woh.event_perfno_i AS "WO",
    woh.ac_registr AS "AC REG",
    TO_CHAR(
        DATE '1971-12-31' + woh.created_date,
        'DD.MON.YYYY'
    ) AS "CREATED DATE",
    TO_CHAR(
        DATE '1971-12-31' + woh.issue_date,
        'DD.MON.YYYY'
    ) AS "ISSUE DATE",
    TO_CHAR(
        DATE '1971-12-31' + wot.absolute_due_date,
        'DD.MON.YYYY'
    ) AS "ESTIMATED SERVICE DATE" due_tah.due_TAH AS "FH",
    due_tac.due_TAC AS "FC",
    dbl.ref_type AS "DLYRP",
    dbl.description AS "DLYRP TYPE",
    wtd.header AS "DEFECT",
    wtd.text AS "ACTION TAKEN"
FROM
    wo_header woh
    LEFT JOIN wo_transfer wot ON woh.event_perfno_i = wot.event_perfno_i
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(
                CAST(
                    (wtd.due_at :: INT) / 60 AS INT
                ) AS VARCHAR
            ) || ':' || RIGHT(
                TO_CHAR(
                    (wtd.due_at || 'SECOND') :: INTERVAL,
                    'HH24:MI:SS'
                ),
                2
            ) AS due_TAH
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'H'
    ) due_tah ON due_tah.event_transferno_i = wot.event_transferno_i
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(wtd.due_at AS INT) AS due_TAC
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'C'
    ) due_tac ON due_tac.event_transferno_i = wot.event_transferno_i
    LEFT JOIN db_link dbl ON woh.event_perfno_i = CAST(dbl.source_pk AS INT)
    LEFT JOIN workstep_link wsl ON woh.event_perfno_i = wsl.event_perfno_i
    LEFT JOIN wo_text_description wtd ON wsl.descno_i = wtd.descno_i
WHERE
    woh.ac_registr LIKE 'A%'
    AND dbl.ref_type = 'DLYRP'
    AND dbl.description = 'SCHEDULE CHECK'
    AND woh.state = 'O';

----- END QUERY -----
/*---- GET DATA WO FOR DLYRP = A330.A321.ACT , HAS DUE_DATE
 - Lấy thêm dữ liệu cols FH FC . Do có thể là wo schedule check.
 */
SELECT
    dl.ref_type AS "Daily Report",
    dl.description AS "Daily Report Type",
    wh.event_perfno_i AS "WO",
    wh.ac_registr AS "AC REG",
    wh.issue_station AS "STATION",
    TO_CHAR(
        DATE '1971-12-31' + wh.created_date,
        'DD.MON.YYYY'
    ) AS "CREATED DATE",
    TO_CHAR(
        DATE '1971-12-31' + wt.absolute_due_date,
        'DD.MON.YYYY'
    ) AS "ESTIMATED SERVICE DATE",
    wtd.header AS "DEFECT",
    wtd.text AS "ACTION TAKEN",
    dl.link_remarks AS "REMARKS",
    dl2_due_date.description AS "DUE DATE",
    due_tah.due_TAH AS "FH",
    due_tac.due_TAC AS "FC"
FROM
    wo_header wh
    INNER JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
    INNER JOIN wo_text_description wtd ON wl.descno_i = wtd.descno_i
    INNER JOIN db_link dl ON CAST(wh.event_perfno_i AS VARCHAR(40)) = dl.source_pk
    INNER JOIN wo_transfer wt ON wh.event_perfno_i = wt.event_perfno_i
    LEFT JOIN db_link dl2_due_date ON dl.source_pk = dl2_due_date.source_pk
    AND dl2_due_date.ref_type = 'DUE_DATE'
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(
                CAST(
                    (wtd.due_at :: INT) / 60 AS INT
                ) AS VARCHAR
            ) || ':' || RIGHT(
                TO_CHAR(
                    (wtd.due_at || 'SECOND') :: INTERVAL,
                    'HH24:MI:SS'
                ),
                2
            ) AS due_TAH
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'H'
    ) due_tah ON due_tah.event_transferno_i = wt.event_transferno_i
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(wtd.due_at AS INT) AS due_TAC
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'C'
    ) due_tac ON due_tac.event_transferno_i = wt.event_transferno_i
WHERE
    wh.ac_registr LIKE 'A%'
    AND dl.ref_type = 'DLYRP'
    AND dl.description = 'A330.A321.ACT'
    AND wh.state = 'O';

/* ---
 ADD NEW COLS FROM DB_LINK TABLE
 1. STS_TYPE
 2. FROM
 3. TO
 */
SELECT
    dl.ref_type AS "Daily Report",
    dl.description AS "Daily Report Type",
    wh.event_perfno_i AS "WO",
    wh.ac_registr AS "AC REG",
    wh.issue_station AS "STATION",
    TO_CHAR(DATE '1971-12-31' + wh.issue_date, 'DD.MON.YYYY') AS "ISSUE DATE",
    TO_CHAR(
        DATE '1971-12-31' + wt.absolute_due_date,
        'DD.MON.YYYY'
    ) AS "ESTIMATED SERVICE DATE",
    wtd.header AS "DEFECT",
    wtd.text AS "ACTION TAKEN",
    dl.link_remarks AS "REMARKS",
    dl2_due_date.description AS "DUE DATE",
    dl3_sts_type.description AS "STS TYPE",
    dl4_from.description AS "FROM",
    dl5_to.description AS "TO",
    due_tah.due_TAH AS "FH",
    due_tac.due_TAC AS "FC"
FROM
    wo_header wh
    INNER JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
    INNER JOIN wo_text_description wtd ON wl.descno_i = wtd.descno_i
    INNER JOIN db_link dl ON CAST(wh.event_perfno_i AS VARCHAR(40)) = dl.source_pk
    INNER JOIN wo_transfer wt ON wh.event_perfno_i = wt.event_perfno_i
    LEFT JOIN db_link dl2_due_date ON dl.source_pk = dl2_due_date.source_pk
    AND dl2_due_date.ref_type = 'DUE_DATE'
    LEFT JOIN db_link dl3_sts_type ON dl.source_pk = dl3_sts_type.source_pk
    AND dl3_sts_type.ref_type = 'STS_TYPE'
    LEFT JOIN db_link dl4_from ON dl.source_pk = dl4_from.source_pk
    AND dl4_from.ref_type = 'FROM'
    LEFT JOIN db_link dl5_to ON dl.source_pk = dl5_to.source_pk
    AND dl5_to.ref_type = 'TO'
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(
                CAST(
                    (wtd.due_at :: INT) / 60 AS INT
                ) AS VARCHAR
            ) || ':' || RIGHT(
                TO_CHAR(
                    (wtd.due_at || 'SECOND') :: INTERVAL,
                    'HH24:MI:SS'
                ),
                2
            ) AS due_TAH
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'H'
    ) due_tah ON due_tah.event_transferno_i = wt.event_transferno_i
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(wtd.due_at AS INT) AS due_TAC
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'C'
    ) due_tac ON due_tac.event_transferno_i = wt.event_transferno_i
WHERE
    wh.ac_registr LIKE 'A%'
    AND dl.ref_type = 'DLYRP'
    AND wh.state = 'O'
UNION
all
SELECT
    NULL AS "Daily Report",
    NULL AS "Daily Report Type",
    NULL AS "WO",
    NULL AS "AC REG",
    NULL AS "STATION",
    NULL AS "ISSUE DATE",
    NULL AS "ESTIMATED SERVICE DATE",
    NULL AS "DEFECT",
    NULL AS "ACTION TAKEN",
    NULL AS "REMARKS",
    NULL AS "DUE DATE",
    NULL AS "STS TYPE",
    NULL AS "FROM",
    NULL AS "TO",
    NULL AS "FH",
    NULL AS "FC"
WHERE
    1 = 0 -- OTHER WAY - GET FROM DB_LINK Table - inner AND LEFT OTHER TABLE
SELECT
    source_pk,
    ref_type,
    description,
    link_remarks,
    wo_header.ac_registr,
    wo_header.issue_station,
    TO_CHAR(
        DATE '1971-12-31' + wo_header.issue_date,
        'DD.MON.YYYY'
    ) AS "ISSUE DATE",
    wo_text_description.header,
    wo_text_description.text,
    TO_CHAR(
        DATE '1971-12-31' + wt.absolute_due_date,
        'DD.MON.YYYY'
    ) AS "ESTIMATED SERVICE DATE",
    due_tah.due_TAH AS "FH",
    due_tac.due_TAC AS "FC" forecast_dimension.dimension,
    forecast_dimension.togo
FROM
    db_link
    INNER JOIN wo_header ON CAST(
        wo_header.event_perfno_i AS VARCHAR(40)
    ) = db_link.source_pk
    INNER JOIN workstep_link ON CAST(db_link.source_pk AS INT) = workstep_link.event_perfno_i
    INNER JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
    INNER JOIN wo_transfer wt ON wo_header.event_perfno_i = wt.event_perfno_i
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(
                CAST(
                    (wtd.due_at :: INT) / 60 AS INT
                ) AS VARCHAR
            ) || ':' || RIGHT(
                TO_CHAR(
                    (wtd.due_at || 'SECOND') :: INTERVAL,
                    'HH24:MI:SS'
                ),
                2
            ) AS due_TAH
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'H'
    ) due_tah ON due_tah.event_transferno_i = wt.event_transferno_i
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(wtd.due_at AS INT) AS due_TAC
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'C'
    ) due_tac ON due_tac.event_transferno_i = wt.event_transferno_i
    INNER JOIN forecast_dimension ON forecast_dimension.event_perfno_i = wo_header.event_perfno_i
WHERE
    db_link.ref_type = 'DLYRP'
WHERE
    ref_type IN (
        'DLYRP',
        'ADD_7D',
        'OPS_LMT'
    )
    AND wo_header.state = 'O' --- GET DATABASE FROM APN 1844
SELECT
    forecast_dimension.togo_neg_tol,
    forecast_dimension.togo_pos_tol,
    forecast_dimension.expected_time_neg_tol,
    forecast_dimension.expected_date_neg_tol,
    forecast_dimension.expected_time_pos_tol,
    forecast_dimension.expected_date_pos_tol,
    forecast_dimension.planned_interval_usage,
    forecast_dimension.dimension,
    forecast_dimension.interval_dimension,
    forecast_dimension.interval_dimension_type,
    forecast_dimension.togo,
    forecast_dimension.togo_pln,
    forecast_dimension.absolute_due_at_ac,
    forecast_dimension.relative_due_at,
    forecast_dimension.absolute_due_at_ac_pln,
    forecast_dimension.since_req,
    forecast_dimension.interval_value,
    forecast_dimension.counter_defno_i,
    forecast_dimension.expected_date,
    forecast_dimension.expected_time,
    forecast_dimension.expected_date_pln,
    forecast_dimension.expected_time_pln,
    forecast_dimension.event_perfno_i,
    forecast_dimension.ref_date,
    forecast_dimension.interpolation,
    forecast_dimension.interval_accuracy,
    forecast_dimension.mutation,
    forecast_dimension.mutator,
    forecast_dimension.status,
    forecast_dimension.mutation_time,
    forecast_dimension.created_by,
    forecast_dimension.created_date
FROM
    forecast_dimension
WHERE
    forecast_dimension.event_perfno_i = 4231894




-----
SELECT
    source_pk,
    ref_type,
    description,
    link_remarks,
    wo_header.ac_registr,
    wo_header.issue_station,
    TO_CHAR(
        DATE '1971-12-31' + wo_header.issue_date,
        'DD.MON.YYYY'
    ) AS "ISSUE DATE",
    wo_text_description.header,
    wo_text_description.text,
    TO_CHAR(
        DATE '1971-12-31' + wt.absolute_due_date,
        'DD.MON.YYYY'
    ) AS "ESTIMATED SERVICE DATE",
    due_tah.due_TAH AS "FH",
    due_tac.due_TAC AS "FC",
    forecast_dimension.dimension,
    CASE
        WHEN forecast_dimension.dimension = 'D' THEN CAST(forecast_dimension.togo / 1440 AS INT)
        WHEN forecast_dimension.dimension = 'H' THEN CAST(forecast_dimension.togo / 60 AS INT)
        WHEN forecast_dimension.dimension = 'C' THEN CAST(forecast_dimension.togo AS INT)
    END AS togo
FROM
    db_link
    INNER JOIN wo_header ON CAST(
        wo_header.event_perfno_i AS VARCHAR(40)
    ) = db_link.source_pk
    INNER JOIN workstep_link ON CAST(db_link.source_pk AS INT) = workstep_link.event_perfno_i
    INNER JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
    INNER JOIN wo_transfer wt ON wo_header.event_perfno_i = wt.event_perfno_i
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(
                CAST(
                    (wtd.due_at :: INT) / 60 AS INT
                ) AS VARCHAR
            ) || ':' || RIGHT(
                TO_CHAR(
                    (wtd.due_at || 'SECOND') :: INTERVAL,
                    'HH24:MI:SS'
                ),
                2
            ) AS due_TAH
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'H'
    ) due_tah ON due_tah.event_transferno_i = wt.event_transferno_i
    LEFT JOIN (
        SELECT
            wtd.event_transferno_i,
            wtd.counterno_i,
            CAST(wtd.due_at AS INT) AS due_TAC
        FROM
            wo_transfer_dimension wtd
            LEFT JOIN counter c ON wtd.counterno_i = c.counterno_i
            LEFT JOIN counter_template ct ON c.counter_templateno_i = ct.counter_templateno_i
            LEFT JOIN counter_definition cd ON ct.counter_defno_i = cd.counter_defno_i
        WHERE
            cd.code = 'C'
    ) due_tac ON due_tac.event_transferno_i = wt.event_transferno_i
    INNER JOIN forecast_dimension ON forecast_dimension.event_perfno_i = wo_header.event_perfno_i
WHERE
    db_link.ref_type = 'DLYRP'
    AND ref_type IN (
        'DLYRP',
        'ADD_7D',
        'OPS_LMT'
    )
    AND wo_header.state = 'O'