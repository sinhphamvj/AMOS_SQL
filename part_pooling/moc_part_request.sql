SELECT part_request_2.supply_in_time_status,
       part_request_2.loc_id_pk,
       part_request_2.part_request_template_i,
       part_request_2.part_requestno_i,
       part_request_2.event_key,
       part_request_2.partno,
       part_request_2.qty,
       part_request_2.initial_qty,
       part_request_2.percentage,
       part_request_2.confirmed_qty,
       part_request_2.parent_part_requestno_i,
       part_request_2.mutation,
       part_request_2.event_type,
       part_request_2.externally_provisioned,
       part_request_2.no_pcf,
       part_request_2.mutator,
       part_request_2.status,
       part_request_2.mutation_time,
       part_request_2.created_by,  --- MOC USER REQUEST PART
       part_request_2.created_date,
       part_request_2.uuid
FROM part_request_2
WHERE part_request_2.part_requestno_i = 9345455  
