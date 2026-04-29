SELECT
    s.firstname,
    s.status,
    s.lastname,
    s.employee_no,
    s.auth_number,
    s.jobcode,
    s.mech_stamp,
    spq.notes,
    spq.limitation,
    spq.pqs_type_no_i,
    spq.special_text_1,
    CASE
        WHEN s.jobcode IN ('B1LE', 'B2LE') THEN spq.special_text_2
        ELSE ''
    END                                                             AS system,
    TO_CHAR(DATE '1971-12-31' + spq.expiry_date, 'DD Mon YYYY')    AS expiry_date,
    TO_CHAR(DATE '1971-12-31' + s.first_crs_date, 'DD Mon YYYY')   AS first_crs_date,
    spq.ac_type,
    spq.scope,
    aml.aml_expiry_date,
    spt.type_label,
    CASE
        WHEN spt.type_label LIKE '%CAT A%' AND spq.ac_type = 'A320'
            THEN 'CAT II/III, RVSM, PBN'
        WHEN spt.type_label LIKE '%CAT A%' AND spq.ac_type = 'A330'
            THEN 'EDTO; CPDLC & ADS-C,MNPS,PBCS; PBN, CAT II&III,RVSM'
        WHEN spt.type_label NOT LIKE 'CAT A' AND spq.ac_type = 'A320' AND spq.notes LIKE '%8c%'
            THEN 'CAT II/III, RVSM, PBN ,RII/DI'
        WHEN spt.type_label NOT LIKE 'CAT A' AND spq.ac_type = 'A320'
            THEN 'CAT II/III, RVSM, PBN'
        WHEN spt.type_label NOT LIKE 'CAT A' AND spq.ac_type = 'A330' AND spq.notes LIKE '%8c%'
            THEN 'EDTO; CPDLC & ADS-C,MNPS,PBCS; PBN, CAT II&III, RVSM'
        WHEN spt.type_label NOT LIKE 'CAT A' AND spq.ac_type = 'A330'
            THEN 'EDTO; CPDLC & ADS-C,MNPS,PBCS; PBN, CAT II&III, RVSM,RII/DI'
        ELSE ''
    END                                                             AS SPECIAL_OPERATION
FROM
    sign s
    /* --- Qualification & Type --- */
    JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i
                                    AND spq.status = 0
    JOIN staff_pqs_type spt          ON spt.pqs_type_no_i = spq.pqs_type_no_i
                                    AND spt.type_description = 'VJC AUTH'
                                    AND spt.type_label NOT IN ('CAT C', 'CAT B1S', 'CAT B2S')
    /* --- Loại trừ nhân viên có Superseded authorization (SPS) --- */
    LEFT JOIN staff_pqs_qualification spq_sps
        ON  spq_sps.employee_no_i = s.employee_no_i
        AND spq_sps.status = 0
        AND spq_sps.pqs_type_no_i IN (
            SELECT spt2.pqs_type_no_i
            FROM staff_pqs_type spt2
            WHERE spt2.type_label = 'SPS'
        )
    /* --- Loại trừ nhân viên có qualification hết hạn (trừ RECURRENT, GSE-GO, và 1 số type_label) --- */
    LEFT JOIN (
        SELECT DISTINCT spq2.employee_no_i
        FROM staff_pqs_qualification spq2
        JOIN staff_pqs_type spt2   ON spt2.pqs_type_no_i = spq2.pqs_type_no_i
        JOIN staff_pqs_class spc2  ON spc2.pqs_class_no_i = spt2.pqs_class_no_i
        WHERE spq2.expiry_date < CURRENT_DATE - DATE '1971-12-31'
          AND spq2.expiry_date IS NOT NULL
          AND spq2.status = 0
          AND spt2.type_label NOT IN (
              'PROC TVJ',
              'AVSEC-MANAGER',
              'SMS-MANAGER',
              'PDA',
              'SMS-GSE',
              'GSE - QUALIFIED COURSE'
          )
          AND spc2.pqs_class_id NOT IN ('RECURRENT', 'GSE-GO')
    ) expired ON expired.employee_no_i = s.employee_no_i
    /* --- AML expiry date --- */
    LEFT JOIN (
        SELECT
            spq3.employee_no_i,
            TO_CHAR(DATE '1971-12-31' + spq3.expiry_date, 'DD Mon YYYY') AS aml_expiry_date,
            spq3.ac_type
        FROM staff_pqs_qualification spq3
        JOIN staff_pqs_type spt3 ON spt3.pqs_type_no_i = spq3.pqs_type_no_i
        WHERE spt3.type_label = 'AMT'
    ) aml ON aml.employee_no_i = s.employee_no_i
         AND aml.ac_type = spq.ac_type
WHERE
    s.auth_number LIKE '%VJC.CRS%'
    AND s.status = 0
    AND spq_sps.employee_no_i IS NULL   /* Không có SPS */
    AND expired.employee_no_i IS NULL   /* Không có qualification hết hạn */
ORDER BY
    s.auth_number
