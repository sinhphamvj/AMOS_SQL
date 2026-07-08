SELECT 
    "ITEM",
    "WO",
    "wpno_i",
    "wtno_i",
    "JC_TEMPLATE_NUM",
    "JC_LINK_WO_NUM",
    "STATION",
    "AC_REG",
    "EVENT_TYPE",
    "STATUS",
    "START_DATE",
    "START_TIME",
    "END_DATE",
    "END_TIME",
    "GROUND_TIME",
    "PRI",
    "RECORDED_HOURS",
    "TOTAL_HOURS",
    "QTY",
    "SCOPE_STAFF",
    "DESCRIPTION",
    "ACTION_TAKEN",
    "ACTION_TAKEN_HTML",
    "OTHER_REQUIREMENTS"
FROM (
    -- Subquery for wp_assignment
    SELECT
      
        ROW_NUMBER() OVER (PARTITION BY wp_header.ac_registr ORDER BY wp_header.ac_registr) AS "ITEM",
        CASE WHEN wo_header.event_type != 'JC' THEN wp_assignment.event_perfno_i::text ELSE work_template.template_number END AS "WO",
        wp_assignment.wpno_i,
        event_template.wtno_i,
        work_template.template_number AS "JC_TEMPLATE_NUM",
        SPLIT_PART(work_template.template_number, '-', 3) AS "JC_LINK_WO_NUM",
        wp_header.station AS "STATION",
        wp_header.ac_registr AS "AC_REG",
        wo_header.event_type AS "EVENT_TYPE",
        wo_header.state AS "STATUS",
        
TO_CHAR(
                  DATE '1971-12-31' + wp_header.start_date,
                  'DD.MON.YYYY'
               ) AS "START_DATE",
               CASE
                  WHEN (wp_header.start_time + 420) >= 1440 THEN TO_CHAR(
                     TIME '00:00' + (
                        (wp_header.start_time + 420 - 1440) || ' minutes'
                     ) :: interval,
                     'HH24:MI'
                  ) || '+'
                  ELSE TO_CHAR(
                     TIME '00:00' + ((wp_header.start_time + 420) || ' minutes') :: interval,
                     'HH24:MI'
                  )
               END AS "START_TIME",
               TO_CHAR(
                  DATE '1971-12-31' + wp_header.end_date,
                  'DD.MON.YYYY'
               ) AS "END_DATE",
               CASE
                  WHEN (wp_header.end_time + 420) >= 1440 THEN TO_CHAR(
                     TIME '00:00' + ((wp_header.end_time + 420 - 1440) || ' minutes') :: interval,
                     'HH24:MI'
                  ) || '+'
                  ELSE TO_CHAR(
                     TIME '00:00' + ((wp_header.end_time + 420) || ' minutes') :: interval,
                     'HH24:MI'
                  )
               END AS "END_TIME",
             CASE
                        WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
                        ELSE wp_header.end_time - wp_header.start_time
                     END AS "GROUND_TIME",

        wo_header.prio AS "PRI",
        time_captured.duration as "RECORDED_HOURS",
        rm_resource_requirement.total_hours AS "TOTAL_HOURS",
        SUM(rm_resource_requirement.resource_quantity) AS "QTY",
        rm_resource_constraint.char_value AS "SCOPE_STAFF",
        CASE WHEN wo_header.event_type = 'JC' THEN work_template.template_title ELSE wo_text_description.header END AS "DESCRIPTION",
        wo_text_description.text AS "ACTION_TAKEN",
        wo_text_description.text_html AS "ACTION_TAKEN_HTML",
        wo_header_more.other AS "OTHER_REQUIREMENTS"
       
    FROM
        wp_assignment
        JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i 
        JOIN wo_header ON wp_assignment.event_perfno_i = wo_header.event_perfno_i
        LEFT JOIN wo_header_more ON wp_assignment.event_perfno_i = wo_header_more.event_perfno_i
        LEFT JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i 
        LEFT JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
        LEFT JOIN wo_event_link ON wp_assignment.event_perfno_i = wo_event_link.event_perfno_i
        LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
        LEFT JOIN rm_resource_request ON workstep_link.descno_i = rm_resource_request.request_owner_amos_key 
        LEFT JOIN rm_resource_requirement ON rm_resource_request.resource_request_noi = rm_resource_requirement.resource_request_noi
        LEFT JOIN rm_resource_constraint ON rm_resource_requirement.resource_requirement_noi = rm_resource_constraint.resource_requirement_noi
        LEFT JOIN rm_property_type ON rm_resource_constraint.property_type_no_i = rm_property_type.property_type_no_i and rm_property_type.resource_category = 'STAFF'
        LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
        LEFT JOIN time_captured ON time_captured.primkey = wo_header.event_perfno_i
       
    WHERE
        wp_assignment.wpno_i IN (136473) AND        wo_header.state IN ('C')
AND NOT (COALESCE(wo_text_description.header, '') = 'DAILY CHECK')
AND NOT (COALESCE(wo_text_description.header, '') LIKE 'PERFORM CHECK: WEEKLY%')
AND NOT (COALESCE(wo_text_description.header, '') = 'PERFORM CHECK: STAYOVER CHECK (STAYOVER)')
        AND NOT (COALESCE(wo_text_description.header, '') = '10D CHECK')
        AND NOT (wo_header.type = 'PD' AND wo_header.event_type = 'Q')

    GROUP BY
        wp_assignment.event_perfno_i,
        wp_assignment.wpno_i,
        event_template.wtno_i,
        work_template.template_number,
        wp_header.station,
        wp_header.ac_registr,
        wo_header.event_type,
        wo_header.state,
        wp_header.start_date,
        wp_header.start_time,
        wp_header.end_date,
        wp_header.end_time,
        wo_header.prio,
        wo_text_description.header,
        wo_text_description.text,
        wo_text_description.text_html,
        wo_header_more.other,
        wo_event_link.event_name,
        rm_resource_constraint.char_value,
        work_template.template_title,
        workstep_link.descno_i,
        rm_resource_request.request_owner_amos_key,
rm_resource_requirement.resource_requirement_noi,
time_captured.duration

    UNION
    
    -- Subquery for wp_content
    SELECT
        
        ROW_NUMBER() OVER (PARTITION BY wp_header.ac_registr ORDER BY wp_header.ac_registr) AS "ITEM",
       CASE WHEN wo_header.event_type != 'JC' THEN wp_content.event_perfno_i::text ELSE work_template.template_number END AS "WO",
        wp_content.wpno_i,
        event_template.wtno_i,
        work_template.template_number AS "JC_TEMPLATE_NUM",
        SPLIT_PART(work_template.template_number, '-', 3) AS "JC_LINK_WO_NUM",
        wp_header.station AS "STATION",
        wp_header.ac_registr AS "AC_REG",
        wo_header.event_type AS "EVENT_TYPE",
        wo_header.state AS "STATUS",
        
TO_CHAR(
                  DATE '1971-12-31' + wp_header.start_date,
                  'DD.MON.YYYY'
               ) AS "START_DATE",
               CASE
                  WHEN (wp_header.start_time + 420) >= 1440 THEN TO_CHAR(
                     TIME '00:00' + (
                        (wp_header.start_time + 420 - 1440) || ' minutes'
                     ) :: interval,
                     'HH24:MI'
                  ) || '+'
                  ELSE TO_CHAR(
                     TIME '00:00' + ((wp_header.start_time + 420) || ' minutes') :: interval,
                     'HH24:MI'
                  )
               END AS "START_TIME",
               TO_CHAR(
                  DATE '1971-12-31' + wp_header.end_date,
                  'DD.MON.YYYY'
               ) AS "END_DATE",
               CASE
                  WHEN (wp_header.end_time + 420) >= 1440 THEN TO_CHAR(
                     TIME '00:00' + ((wp_header.end_time + 420 - 1440) || ' minutes') :: interval,
                     'HH24:MI'
                  ) || '+'
                  ELSE TO_CHAR(
                     TIME '00:00' + ((wp_header.end_time + 420) || ' minutes') :: interval,
                     'HH24:MI'
                  )
               END AS "END_TIME",
               CASE
                        WHEN wp_header.end_time < wp_header.start_time THEN (wp_header.end_time + 1440) - wp_header.start_time
                        ELSE wp_header.end_time - wp_header.start_time
                     END AS "GROUND_TIME",

        wo_header.prio AS "PRI",
          time_captured.duration as "RECORDED_HOURS",
          (
            SELECT SUM(rreq_sub.total_hours)
            FROM rm_resource_requirement rreq_sub
            JOIN rm_resource_request rreq_inner ON rreq_sub.resource_request_noi = rreq_inner.resource_request_noi
  LEFT JOIN rm_resource_constraint ON rm_resource_requirement.resource_requirement_noi = rm_resource_constraint.resource_requirement_noi
LEFT JOIN rm_property_type ON rm_resource_constraint.property_type_no_i = rm_property_type.property_type_no_i 
            JOIN workstep_link ws_link_sub ON rreq_inner.request_owner_amos_key = ws_link_sub.descno_i
            WHERE ws_link_sub.event_perfno_i =  wp_content.event_perfno_i
and rm_property_type.resource_category = 'STAFF'
        ) AS "TOTAL_HOURS",
        SUM(rm_resource_requirement.resource_quantity) AS "QTY",
        rm_resource_constraint.char_value AS "SCOPE_STAFF",
        CASE WHEN wo_header.event_type = 'JC' THEN work_template.template_title ELSE wo_text_description.header END AS "DESCRIPTION",
        wo_text_description.text AS "ACTION_TAKEN",
        wo_text_description.text_html AS "ACTION_TAKEN_HTML",
        wo_header_more.other AS "OTHER_REQUIREMENTS"
        
    FROM
        wp_content
        JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i 
        JOIN wo_header ON wp_content.event_perfno_i = wo_header.event_perfno_i
        LEFT JOIN wo_header_more ON wp_content.event_perfno_i = wo_header_more.event_perfno_i
        LEFT JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i AND workstep_link.sequenceno = 1
        LEFT JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
        LEFT JOIN wo_event_link ON wp_content.event_perfno_i = wo_event_link.event_perfno_i
        LEFT JOIN event_template ON wo_header.template_revisionno_i = event_template.template_revisionno_i
        LEFT JOIN rm_resource_request ON workstep_link.descno_i = rm_resource_request.request_owner_amos_key 
        LEFT JOIN rm_resource_requirement ON rm_resource_request.resource_request_noi = rm_resource_requirement.resource_request_noi
        LEFT JOIN rm_resource_constraint ON rm_resource_requirement.resource_requirement_noi = rm_resource_constraint.resource_requirement_noi
        LEFT JOIN rm_property_type ON rm_resource_constraint.property_type_no_i = rm_property_type.property_type_no_i and rm_property_type.resource_category = 'STAFF'
        LEFT JOIN work_template ON event_template.wtno_i = work_template.wtno_i
        LEFT JOIN time_captured ON time_captured.primkey = wo_header.event_perfno_i
        
    WHERE
        wp_content.wpno_i IN  (136473) AND        wo_header.state IN ('C') AND wo_header.event_type <> 'JC'
      AND NOT (COALESCE(wo_text_description.header, '') = 'DAILY CHECK')
AND NOT (COALESCE(wo_text_description.header, '') LIKE 'PERFORM CHECK: WEEKLY%')
AND NOT (COALESCE(wo_text_description.header, '') = 'PERFORM CHECK: STAYOVER CHECK (STAYOVER)')
        AND NOT (COALESCE(wo_text_description.header, '') = '10D CHECK')
        AND NOT (wo_header.type = 'PD' AND wo_header.event_type = 'Q')
    GROUP BY
        wp_content.event_perfno_i,
        wp_content.wpno_i,
        event_template.wtno_i,
        work_template.template_number,
        wp_header.station,
        wp_header.ac_registr,
        wo_header.event_type,
        wo_header.state,
        wp_header.start_date,
        wp_header.start_time,
        wp_header.end_date,
        wp_header.end_time,
        wo_header.prio,
        wo_text_description.header,
        wo_text_description.text,
        wo_text_description.text_html,
        wo_header_more.other,
        wo_event_link.event_name,
        rm_resource_constraint.char_value,
        work_template.template_title,
        workstep_link.descno_i,
        rm_resource_request.request_owner_amos_key,
      rm_resource_requirement.resource_requirement_noi,
      time_captured.duration
) AS combined_subquery
ORDER BY
    CASE
        WHEN "STATION" = 'SGN' THEN 1
        WHEN "STATION" = 'HAN' THEN 2
        WHEN "STATION" = 'DAD' THEN 3
        WHEN "STATION" = 'CXR' THEN 4
        WHEN "STATION" = 'HPH' THEN 5
        WHEN "STATION" = 'VCA' THEN 6
        WHEN "STATION" = 'PQC' THEN 7
        ELSE 8
    END,
    "AC_REG",
    "ITEM"