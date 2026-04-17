SELECT work_template.preparation,
       work_template.uuid,
       work_template.template_title,
       work_template.template_type,
       work_template.template_number,
       work_template.parent_wtno_i,
       work_template.wtno_i,
       work_template.mutation,
       work_template.mutator,
       work_template.status,
       work_template.mutation_time,
       work_template.created_by,
       work_template.created_date
FROM work_template
WHERE work_template.template_title LIKE 'CAAV-F586-SECTION5-B1-%'

