SELECT 
       wh.ac_registr AS "AC_REG",
       approval_document.due_date,
       approval_document.trigger_point,
       approval_document.request_date,
       approval_document.request_time,
       approval_document.approval_type,
       approval_document.document_owner,
       approval_document.document_type,
       approval_document.document_key,
       approval_document.approval_state,
       approval_document.requested_by,
       approval_document.rule_id,
       approval_document.apn,
       approval_document.document_handle,
       approval_document.approval_documentno_i,
       approval_document.mutation,
       approval_document.mutator,
       approval_document.status,
       approval_document.mutation_time,
       approval_document.created_by,
       approval_document.created_date
FROM approval_document
LEFT JOIN sign ON approval_document.requested_by = sign.user_sign
LEFT JOIN wo_header as wh ON approval_document.document_key = wh.event_perfno_i
WHERE  
sign.lastname LIKE '%MOC'
AND approval_document.approval_state = 'APR'
AND approval_document.rule_id = 6403
AND wh.state = 'O'
AND wh.ac_registr != 'COMP'
