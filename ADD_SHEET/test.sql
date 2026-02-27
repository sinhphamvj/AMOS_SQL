SELECT
    valid_staff.firstname,
    sign.status,
    valid_staff.lastname,
    valid_staff.employee_no,
    valid_staff.auth_number,
    valid_staff.jobcode,
    valid_staff.mech_stamp,
    valid_staff.notes,
    valid_staff.limitation,
    valid_staff.pqs_type_no_i,
    valid_staff.special_text_1,
    valid_staff.system,
    valid_staff.expiry_date,
    valid_staff.char_value AS "REMARKS",
    aml.aml_expiry_date,
    staff_pqs_type.type_label
FROM
    staff_pqs_type
    RIGHT JOIN (
        SELECT DISTINCT
            s.firstname,
            s.lastname,
            s.employee_no,
            s.employee_no_i,
            s.auth_number,
            s.jobcode,
            s.mech_stamp,
            spq.notes,
            spq.limitation,
            spq.ac_type,
            spq.number_text,
            rm_property_value.char_value,
            spq.pqs_type_no_i,
            TO_CHAR(
                DATE '1971-12-31' + spq.expiry_date,
                'DD Mon YYYY'
            ) AS expiry_date,
            spq.special_text_1,
            CASE
                WHEN s.jobcode = 'B1LE' THEN spq.special_text_2
                WHEN s.jobcode = 'B2LE' THEN spq.special_text_2
                ELSE ''
            END AS system /* spq.special_text_2 AS system*/
        FROM
            sign s
            LEFT JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i
            LEFT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i
            LEFT JOIN rm_property_value ON rm_property_value.owner_amos_key = spq.pqs_qualification_no_i
        WHERE
            s.employee_no_i NOT IN (
                SELECT
                    s.employee_no_i
                FROM
                    sign s
                    LEFT JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i
                    LEFT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i
                    LEFT JOIN staff_pqs_class ON staff_pqs_type.pqs_class_no_i = staff_pqs_class.pqs_class_no_i
                    LEFT JOIN (
                        SELECT
                            s.employee_no
                        FROM
                            sign s
                            RIGHT JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i
                            RIGHT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i
                            RIGHT JOIN staff_pqs_class ON staff_pqs_type.pqs_class_no_i = staff_pqs_class.pqs_class_no_i
                        WHERE
                            staff_pqs_type.type_label = 'SPS'
                            AND spq.status = 0
                    ) sus ON sus.employee_no = s.employee_no
                WHERE
                    spq.expiry_date < CURRENT_DATE - '1971-12-31'
                    AND spq.expiry_date IS NOT NULL
                    AND (s.auth_number LIKE '%VJC.CRS%')
                    AND staff_pqs_type.type_label NOT IN (
                        'PROC TVJ',
                        'AVSEC-MANAGER',
                        'SMS-MANAGER',
                        'PDA',
                        'SMS-GSE',
                        'GSE - QUALIFIED COURSE'
                    )
                    AND staff_pqs_class.pqs_class_id <> 'RECURRENT'
                    AND staff_pqs_class.pqs_class_id <> 'GSE-GO'
                    AND spq.status = 0
            ) /*to exclude staff with expired qualification (exclude TVJ PROC recurrent*/
            AND s.employee_no_i NOT IN (
                SELECT
                    s.employee_no_i
                FROM
                    sign s
                    RIGHT JOIN staff_pqs_qualification spq ON spq.employee_no_i = s.employee_no_i
                    RIGHT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i
                    RIGHT JOIN staff_pqs_class ON staff_pqs_type.pqs_class_no_i = staff_pqs_class.pqs_class_no_i
                WHERE
                    staff_pqs_type.type_label = 'SPS'
                    AND spq.status = 0
            ) /*to exclude staff with superseded authorization*/
            AND staff_pqs_type.type_description = 'VJC AUTH'
            AND spq.pqs_type_no_i NOT IN (7371, 8071,8072)
            AND rm_property_value.owner_amos_type = 'PQSE'
          AND rm_property_value.char_value IS NOT NULL
    ) valid_staff ON valid_staff.pqs_type_no_i = staff_pqs_type.pqs_type_no_i
    LEFT JOIN sign ON sign.employee_no_i = valid_staff.employee_no_i
    LEFT JOIN (
        SELECT
            sign.employee_no_i,
            TO_CHAR(
                DATE '1971-12-31' + spq.expiry_date,
                'DD Mon YYYY'
            ) AS aml_expiry_date,
            spq.ac_type
        FROM
            sign
            LEFT JOIN staff_pqs_qualification spq ON spq.employee_no_i = sign.employee_no_i
            LEFT JOIN staff_pqs_type ON staff_pqs_type.pqs_type_no_i = spq.pqs_type_no_i
        WHERE
            staff_pqs_type.type_label = 'AMT'
    ) aml ON aml.employee_no_i = valid_staff.employee_no_i
    AND aml.ac_type = valid_staff.ac_type
WHERE /*staff_pqs_type.type_description ='VJC AUTH'
      AND*/
    valid_staff.lastname LIKE '%VJC.CRS%'
    AND sign.status = 0
ORDER BY
    valid_staff.lastname

