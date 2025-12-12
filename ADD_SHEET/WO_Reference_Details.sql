SELECT     source_pk,
       MAX(
          CASE WHEN ref_type = 'TLOP' THEN UPPER(description) END                                                                
       ) AS tlop_description,
       MAX(
          CASE WHEN ref_type = 'ADD' THEN UPPER(description) END                                                                
       ) AS add_description,
       MAX(
          CASE WHEN  ref_type = 'ADD' THEN UPPER(link_remarks) END                                                                
       ) AS link_remarks,
       MAX(
          CASE WHEN ref_type = 'REP_MNT' THEN UPPER(description) END                                                                
       ) AS rep_maint_desc,
       MAX(
          CASE WHEN ref_type = 'WO'                                                                                         
          and link_remarks = 'REPETITIVE INSPECTION' THEN UPPER(description) END                                                                
       ) AS wo_rep_maint_desc,
       MAX(
          CASE WHEN ref_type = 'DOC_REF' THEN UPPER(description) END                                                                
       ) AS doc_ref_description,
       MAX(
          CASE WHEN ref_type = 'MP' THEN UPPER(description) END                                                                
       ) AS mp_description,
       MAX(
          CASE WHEN ref_type = 'OPS' THEN UPPER(description) END                                                                
       ) AS ops_description,
       MAX(
          CASE WHEN ref_type = 'OPSLIMIT' THEN UPPER(description) END                                                                
       ) AS opslimit_description,
       MAX(
          CASE WHEN ref_type = 'REP_MNT' THEN CAST(source_pk AS INT) END                                                                
       ) AS source_no         
FROM db_link        
WHERE source_pk::VARCHAR = COALESCE('@MCC Open MEL per Aircraft.wo_header.event_perfno_i@'::VARCHAR, 'Null')
      AND source_type = 'WO'         
GROUP BY source_pk