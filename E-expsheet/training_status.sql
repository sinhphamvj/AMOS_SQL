SELECT 
    tm.item AS "STT",
    tm.course_title AS "COURSE_NAME",
    CASE 
        WHEN tm.req_cat_a = '' THEN 'N/A'
        WHEN q.start_date IS NOT NULL THEN 'X'
        ELSE 'N/A'
    END AS "REQ_CAT_A",
    CASE 
        WHEN tm.req_cat_b1 = '' THEN 'N/A'
        WHEN q.start_date IS NOT NULL THEN 'X'
        ELSE 'N/A'
    END AS "REQ_CAT_B1",
    CASE 
        WHEN tm.req_cat_b2 = '' THEN 'N/A'
        WHEN q.start_date IS NOT NULL THEN 'X'
        ELSE 'N/A'
    END AS "REQ_CAT_B2",
    COALESCE(TO_CHAR(DATE '1971-12-31' + q.start_date, 'DD.MON.YYYY'), '') AS "START_DATE",
    COALESCE(TO_CHAR(DATE '1971-12-31' + q.end_date, 'DD.MON.YYYY'), '') AS "END_DATE",
    COALESCE(q.special_text_1, '') AS "TRAINING_RESOURCE"
FROM (
    VALUES
    (1, 'VJC Procedures for Contracted AMO (Line) (included DI course)', 11097, 'X', 'X', 'X'),
    (2, 'VJC AMO Procedures (included VARs regulations as associated)', 11084, 'X', 'X', 'X'),
    (3, 'Safety Management System', 42, 'X', 'X', 'X'),
    (4, 'Human Factor', 33, 'X', 'X', 'X'),
    (5, 'Aviation Security', 35, 'X', 'X', 'X'),
    (6, 'Ramp Safety', 313, 'X', 'X', 'X'),
    (7, 'Aircraft Type Rating', 7372, 'Cat A1', 'Cat B1.1', 'Cat B2'),
    (8, 'RVSM, PBN & Autoland CAT II/ III for Maintenance', 312, 'X', 'X', 'X'),
    (9, 'De-icing/Anti-Icing', 476, 'X', 'X', 'X'),
    (10, 'EDTO (only for A330 Certifying Staffs)', 4274, 'X', 'X', 'X'),
    (11, 'Fuel Tank Safety (FTS)', 5001, '', 'Phase 1&2', 'Phase 1&2'),
    (12, 'Electrical Wiring Interconnection System (EWIS)', 5002, '', 'Group 2', 'Group 2'),
    (13, 'Engine Run-Up (both theory and simulator)', 5003, '', 'X', ''),
    (14, 'Engine Borescope Inspection Training', 5004, '', 'X', ''),
    (15, 'AMOS for CRS', 5005, 'X', 'X', 'X'),
    (16, 'ETLB Training', 5006, 'X', 'X', 'X'),
    (17, 'Specific Tool/ Equipment', 5007, 'X', 'X', 'X'),
    (18, 'Base Maintenance SOP (only for Base Maintenance Roster)', 5008, 'X', 'X', 'X'),
    (19, 'Requirements from Laos Authority and Laos Airlines (if required) (only for Base Maintenance Roster)', 5009, 'X', 'X', 'X')
) tm(item, course_title, pqs_type_id, req_cat_a, req_cat_b1, req_cat_b2)
LEFT JOIN (
    SELECT DISTINCT ON (pqs_type_no_i)
        pqs_type_no_i,
        start_date,
        end_date,
        special_text_1
    FROM staff_pqs_qualification
    WHERE employee_no_i = (
        SELECT employee_no_i 
        FROM sign 
        WHERE user_sign = 'VJC8994'
    )
      AND status = 0
    ORDER BY pqs_type_no_i, start_date DESC
) q ON tm.pqs_type_id = q.pqs_type_no_i
ORDER BY tm.item