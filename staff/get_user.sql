SELECT
sign.user_sign as "VJCID",
sign.firstname as "FIRST_NAME",
sign.lastname as "LAST_NAME",
sign.department as "DEPARTMENT",
sign.homebase as "HOMEBASE",
sign.workgroup as "WORKGROUP",
staff_pqs_class.pqs_class_id as "PQS_CLASS_ID",
staff_pqs_type.type_label as "PQS_TYPE_LABEL",
staff_pqs_typetype_description as "PQS_TYPE_DESCRIPTION",
staff_pqs_qualification.scope as "SCOPE",
staff_pqs_qualification.skill as "SKILL",
staff_pqs_qualification.ac_type as "AC_TYPE",
staff_pqs_qualification.limitation as "LIMITATION",
staff_pqs_qualification.notes as "NOTES"

FROM
sign
JOIN staff_pqs_qualification on sign.employee_no_i = staff_pqs_qualification.employee_no_i
JOIN staff_pqs_type ON staff_pqs_qualification.pqs_type_no_i = staff_pqs_type.pqs_type_no_i 
JOIN staff_pqs_class ON staff_pqs_type.pqs_class_no_i = staff_pqs_class.pqs_class_no_i 
WHERE
sign.user_sign = 'VJC0787'
and staff_pqs_class.pqs_class_id = 'SAFETY'
and staff_pqs_qualification.status <> 9
