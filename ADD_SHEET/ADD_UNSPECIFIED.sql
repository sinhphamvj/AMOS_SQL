SELECT 
event_effectivity.title as "AC_REG"
FROM 
event_template
LEFT JOIN worktemplate_link ON event_template.wtno_i = worktemplate_link.wtno_i
LEFT JOIN event_effectivity_link ON event_effectivity_link.effectivity_linkno_i = worktemplate_link.event_key
LEFT JOIN event_effectivity ON event_effectivity_link.effectivityno_i = event_effectivity.effectivityno_i
WHERE
event_template.template_revisionno_i =  (@VAR.TEMP_REV_NO_8D@)
AND AND event_effectivity_link.event_type = 'CHT'