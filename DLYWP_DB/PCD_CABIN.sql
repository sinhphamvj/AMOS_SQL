SELECT 
    -- Tổng số nhiệm vụ Mandatory (ASSIGNED với prio = 'M')
    SUM(CASE WHEN "TASK_TYPE" = 'ASSIGNED' THEN "TASK_COUNT" ELSE 0 END) AS "ASSINGED_CABIN_TOTAL",
    
    -- Tổng số nhiệm vụ Deferred (DEFERRED với prio = 'M')
    SUM(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END) AS "DEFERRED_CABIN_TOTAL",
    
    -- Tổng số nhiệm vụ Closed (CLOSED với prio = 'M')
    (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END)-
     MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) AS "CLOSED_CABIN_TOTAL",
    
    -- Tổng số nhiệm vụ (Mandatory + Deferred)
    (MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) +
     MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END)-
     MAX(CASE WHEN "TASK_TYPE" = 'JC_NOT_PERFORMED' THEN "TASK_COUNT" ELSE 0 END)) AS "TOTAL_CABIN_TASK"
    
FROM (
    -- Query cho ASSIGNED TOTAL
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'ASSIGNED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i 
    JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
    LEFT JOIN wo_header_more ON wp_assignment.event_perfno_i = wo_header_more.event_perfno_i
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
    JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
    LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
    LEFT JOIN rm_resource_request ON workstep_link.descno_i = rm_resource_request.request_owner_amos_key 
    LEFT JOIN rm_resource_requirement ON rm_resource_request.resource_request_noi = rm_resource_requirement.resource_request_noi
    LEFT JOIN rm_resource_constraint ON rm_resource_requirement.resource_requirement_noi = rm_resource_constraint.resource_requirement_noi
    LEFT JOIN rm_property_type ON rm_resource_constraint.property_type_no_i = rm_property_type.property_type_no_i
    WHERE         
    wp_assignment.wpno_i IN (@VAR.WP@) 
    AND wo_header.state IN ('C','O')
    AND rm_resource_constraint.char_value IN ('CAM','CAB','CA')

    UNION ALL
    
    -- Query cho DEFERRED_CABIN_TOTAL 
    SELECT COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'DEFERRED' AS "TASK_TYPE"
    FROM wp_content
    JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i 
    JOIN wo_header ON wp_content.event_perfno_i = wo_header.event_perfno_i
    LEFT JOIN wo_header_more ON wp_content.event_perfno_i = wo_header_more.event_perfno_i
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
    JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
    LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
    LEFT JOIN rm_resource_request ON workstep_link.descno_i = rm_resource_request.request_owner_amos_key 
    LEFT JOIN rm_resource_requirement ON rm_resource_request.resource_request_noi = rm_resource_requirement.resource_request_noi
    LEFT JOIN rm_resource_constraint ON rm_resource_requirement.resource_requirement_noi = rm_resource_constraint.resource_requirement_noi
    LEFT JOIN rm_property_type ON rm_resource_constraint.property_type_no_i = rm_property_type.property_type_no_i
    WHERE         
        wp_content.wpno_i IN (@VAR.WP@) 
        AND wo_header.state IN ('C','O')
        AND wp_content.event_status = 'N'
        AND rm_resource_constraint.char_value IN ('CAM','CAB','CA')

    UNION ALL
    
    -- Query cho CLOSED_CABIN TOTAL
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'CLOSED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i 
    JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
    LEFT JOIN wo_header_more ON wp_assignment.event_perfno_i = wo_header_more.event_perfno_i
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
    JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
    LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
    LEFT JOIN rm_resource_request ON workstep_link.descno_i = rm_resource_request.request_owner_amos_key 
    LEFT JOIN rm_resource_requirement ON rm_resource_request.resource_request_noi = rm_resource_requirement.resource_request_noi
    LEFT JOIN rm_resource_constraint ON rm_resource_requirement.resource_requirement_noi = rm_resource_constraint.resource_requirement_noi
    LEFT JOIN rm_property_type ON rm_resource_constraint.property_type_no_i = rm_property_type.property_type_no_i
    WHERE         
    wp_assignment.wpno_i IN (@VAR.WP@) 
    AND wo_header.state ='C'
    AND rm_resource_constraint.char_value IN ('CAM','CAB','CA')

    UNION ALL
    
    -- Query cho TOTAL JC NOT PERFORMED
    SELECT COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'JC_NOT_PERFORMED' AS "TASK_TYPE"
    FROM wp_content
   JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i 
    JOIN wo_header ON wp_content.event_perfno_i = wo_header.event_perfno_i
    LEFT JOIN wo_header_more ON wp_content.event_perfno_i = wo_header_more.event_perfno_i
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
    JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
    LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
    LEFT JOIN rm_resource_request ON workstep_link.descno_i = rm_resource_request.request_owner_amos_key 
    LEFT JOIN rm_resource_requirement ON rm_resource_request.resource_request_noi = rm_resource_requirement.resource_request_noi
    LEFT JOIN rm_resource_constraint ON rm_resource_requirement.resource_requirement_noi = rm_resource_constraint.resource_requirement_noi
    LEFT JOIN rm_property_type ON rm_resource_constraint.property_type_no_i = rm_property_type.property_type_no_i
    WHERE wp_content.wpno_i IN (@VAR.WP@)
    AND wo_header.state = 'C'AND wo_header.event_type = 'JC'
    AND wp_content.event_status = 'N'
        AND rm_resource_constraint.char_value IN ('CAM','CAB','CA')

) AS task_counts
