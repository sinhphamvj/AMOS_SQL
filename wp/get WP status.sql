--  Get WP status
SELECT wp_status.sort_no,
       wp_status.name,
       CASE WHEN wp_status.wp_type = 2 THEN 'Component Workpackage' ELSE 'Aircraft Workpackage' END AS wp_type_name,
       wp_status.wp_status_id
FROM wp_status
WHERE wp_status.wp_type = 0  

-- Get all aircraft list for WP

SELECT DISTINCT forecast.ac_registr
FROM forecast  

SELECT DISTINCT part_forecast.receiver
FROM part_forecast
WHERE part_forecast.receiver_type = 'AC'  


--  Get all aircraft list information

SELECT aircraft.ac_registr,
       aircraft.description,
       aircraft.ac_typ,
       aircraft.ac_model,
       aircraft.ac_subtype,
       ac_typ.description,
       aircraft.owner,
       aircraft.operator,
       aircraft.homebase,
       aircraft.object_type,
       CASE WHEN aircraft.status <> 9 THEN 'Active' ELSE 'Inactive' END,
       CASE aircraft.non_managed WHEN 'Y' THEN 'Non-Managed' ELSE 'Managed' END,
       CASE WHEN aircraft.ac_registr IN (
          'A629',
          'COMP',
          'A639',
          'A636',
          'A637',
          'A634',
          'A635',
          'A632',
          'A633',
          'A630',
          'VKB',
          'A631',
          'VKA',
          'VKD',
          'VKC',
          'VKF',
          'VKE',
          'VKH',
          'VKG',
          'VKJ',
          'VKL',
          'VKN',
          'VKM',
          'VKP',
          'VKO',
          'VKR',
          'VKQ',
          'VKT',
          'VKS',
          'A528',
          'A649',
          'A529',
          'A526',
          'A647',
          'A527',
          'A648',
          'A524',
          'A645',
          'A525',
          'A646',
          'A522',
          'A643',
          'A523',
          'A644',
          'A641',
          'A521',
          'A642',
          'A640',
          'A816',
          'A817',
          'A814',
          'A815',
          'A537',
          'A658',
          'A812',
          'A538',
          'A535',
          'A656',
          'A810',
          'A536',
          'A657',
          'A811',
          'A533',
          'A654',
          'A534',
          'A655',
          'A531',
          'A652',
          'A532',
          'A653',
          'A650',
          'DUMMY',
          'A530',
          'A651',
          'A669',
          'A667',
          'A668',
          'A544',
          'A666',
          'A542',
          'A663',
          'A540',
          'A661',
          'A662',
          'A676',
          'A677',
          'A674',
          'A675',
          'A672',
          'A673',
          'A670',
          'A671',
          'A607',
          'A689',
          'A687',
          'A600',
          'A685',
          'A683',
          'A684',
          'A698',
          'A699',
          'A697',
          'A694',
          'A695',
          'A693',
          'A690',
          'A691'
       ) THEN 'In forecast' ELSE 'Not in forecast' END,
       aircraft.aircraftno_i,
       CASE WHEN wb_aircraft_link.wb_fleet_code IS NULL THEN '' ELSE wb_aircraft_link.wb_fleet_code END,
       CASE WHEN wb_aircraft_link.wb_cabin_version IS NULL THEN '' ELSE wb_aircraft_link.wb_cabin_version END,
       CASE WHEN (
          aircraft.ac_registr IN (
             'A629',
             'COMP',
             'A639',
             'A636',
             'A637',
             'A634',
             'A635',
             'A632',
             'A633',
             'A630',
             'VKB',
             'A631',
             'VKA',
             'VKD',
             'VKC',
             'VKF',
             'VKE',
             'VKH',
             'VKG',
             'VKJ',
             'VKL',
             'VKN',
             'VKM',
             'VKP',
             'VKO',
             'VKR',
             'VKQ',
             'VKT',
             'VKS',
             'A528',
             'A649',
             'A529',
             'A526',
             'A647',
             'A527',
             'A648',
             'A524',
             'A645',
             'A525',
             'A646',
             'A522',
             'A643',
             'A523',
             'A644',
             'A641',
             'A521',
             'A642',
             'A640',
             'A816',
             'A817',
             'A814',
             'A815',
             'A537',
             'A658',
             'A812',
             'A538',
             'A535',
             'A656',
             'A810',
             'A536',
             'A657',
             'A811',
             'A533',
             'A654',
             'A534',
             'A655',
             'A531',
             'A652',
             'A532',
             'A653',
             'A650',
             'DUMMY',
             'A530',
             'A651',
             'A669',
             'A667',
             'A668',
             'A544',
             'A666',
             'A542',
             'A663',
             'A540',
             'A661',
             'A662',
             'A676',
             'A677',
             'A674',
             'A675',
             'A672',
             'A673',
             'A670',
             'A671',
             'A607',
             'A689',
             'A687',
             'A600',
             'A685',
             'A683',
             'A684',
             'A698',
             'A699',
             'A697',
             'A694',
             'A695',
             'A693',
             'A690',
             'A691'
          )
          OR aircraft.ac_registr IS NULL
       ) THEN 'In forecast' ELSE 'Not in forecast' END,
       aircraft.serialno,
       msc_maintenance_program.mpno,
       CASE aircraft.investigation WHEN 'Y' THEN 'Under Investigation' ELSE '' END,
       aircraft.asset_owner,
       aircraft.maintenance_provider,
       aircraft.manufacturer,
       address.vendor,
       CASE WHEN ac_suspension.suspension_date IS NULL THEN '' ELSE 'Suspended' END,
       aircraft.init_status
FROM aircraft
LEFT JOIN ac_typ ON aircraft.ac_typ = ac_typ.ac_typ
LEFT JOIN wb_aircraft_link ON aircraft.aircraftno_i = wb_aircraft_link.aircraftno_i
LEFT JOIN msc_ac_configuration ON aircraft.aircraftno_i = msc_ac_configuration.aircraftno_i AND msc_ac_configuration.program_type = 'OMP' AND msc_ac_configuration.mpno_i NOT IN (
             SELECT msc_mp_link.mpno_i_operator
             FROM msc_mp_link
             WHERE msc_mp_link.mpno_i_requirement = -11
          ) AND msc_ac_configuration.status = 0
LEFT JOIN msc_maintenance_program ON msc_ac_configuration.mpno_i = msc_maintenance_program.mpno_i
LEFT JOIN address ON aircraft.auth_address_i = address.address_i
LEFT JOIN ac_suspension ON ac_suspension.aircraftno_i = aircraft.aircraftno_i AND (ac_suspension.status = 0)
WHERE aircraft.ac_registr <> ''  


-- Get Operator list
SELECT address.vendor,
       address.name,
       adr_details.address,
       adr_details.city,
       adr_details.country,
       address.status,
       address.address_i
FROM address
LEFT JOIN adr_details ON address.linked_detail = adr_details.address_i
WHERE (
         EXISTS (
            SELECT adr_properties.address_i
            FROM adr_properties
            WHERE adr_properties.address_i = address.address_i
                  AND adr_properties.prop_type_i = 4
         )
      )
      AND address.status <> 9  
-- Get wp status = Open, Close, In Progress

SELECT wp_status.sort_no,
       wp_status.name,
       CASE WHEN wp_status.wp_type = 2 THEN 'Component Workpackage' ELSE 'Aircraft Workpackage' END AS wp_type_name,
       wp_status.wp_status_id
FROM wp_status
WHERE wp_status.wp_type = 0  

--  GEt all address list

SELECT address.incomingincoterm,
       address.discount,
       address.address_i,
       address.parent,
       address.vendor,
       address.type_i,
       address.name,
       address.name_1,
       address.name_2,
       address.contact_name,
       address.currency,
       address.linked_adr,
       address.linked_detail,
       address.remarks,
       address.default_tax_code,
       address.shipment,
       address.ship_via,
       address.paymentcondition,
       address.deliverycondition,
       address.black_list,
       address.black_list_since,
       address.black_list_text,
       address.status,
       address.homebase,
       address.costcenter,
       address.resource_type_id,
       address.bill_text,
       address.bill_payment_cond,
       address.mutator,
       address.mutation,
       address.mutation_time,
       address.created_by,
       address.created_date,
       adr_details.address_i,
       adr_details.address,
       adr_details.address_1,
       adr_details.city,
       adr_details.country,
       adr_details.zip_code,
       adr_details.time_zone,
       adr_details.state,
       adr_details.status,
       adr_details.mutator,
       adr_details.mutation,
       adr_details.mutation_time,
       adr_details.created_by,
       adr_details.created_date
FROM address
JOIN adr_details ON address.linked_detail = adr_details.address_i
WHERE address.vendor = 'VJC'
      AND (
         EXISTS (
            SELECT adr_properties.address_i
            FROM adr_properties
            WHERE adr_properties.address_i = address.address_i
                  AND adr_properties.prop_type_i = 4
         )
         AND address.status <> 9
      )  


--  Get list of WP
-- wpno_i , ac_resgistr, station, start_date, end_date, start_time, end_time , description , internal_remarks, remak
--
--
SELECT wp_header.amm_oem_noi,
       wp_header.handed_to_prod_group,
       wp_header.mp_order_detailno_i,
       wp_header.target_end_time,
       wp_header.target_start_time,
       wp_header.return_type,
       wp_header.target_start_date,
       wp_header.est_end_time,
       wp_header.est_end_date,
       wp_header.est_start_time,
       wp_header.est_start_date,
       wp_header.comp_owner,
       wp_header.rc_order_detailno_i,
       wp_header.r_order_detailno_i,
       wp_header.use_new_certificates,
       wp_header.shop_arrival_time,
       wp_header.shop_arrival_date,
       wp_header.partially_imported,
       wp_header.esign_manually_set,
       wp_header.esign_policy,
       wp_header.req_condition,
       wp_header.part_description,
       wp_header.lm_groundtimeno_i,
       wp_header.inbound_scheduled_time,
       wp_header.inbound_scheduled_date,
       wp_header.departure_fltno,
       wp_header.is_imported,
       wp_header.ac_operator,
       wp_header.ac_model,
       wp_header.ac_subtype,
       wp_header.contact_person,
       wp_header.shop,
       wp_header.target_end_date,
       wp_header.partno,
       wp_header.next_flight_legno_i,
       wp_header.mpno,
       wp_header.engines_apu_serial,
       wp_header.test_flight,
       wp_header.cust_address,
       wp_header.auto_generated,
       wp_header.jobcards_collection_status,
       wp_header.internal_remarks,
       wp_header.quotationno_i,
       wp_header.wp_type,
       wp_header.drop_locationno_i,
       wp_header.wpno_i,
       wp_header.wpno,
       wp_header.ac_registr,
       wp_header.ac_typ,
       wp_header.projectno,
       wp_header.est_groundtime,
       wp_header.station,
       wp_header.start_date,
       wp_header.start_time,
       wp_header.arrival_fltno,
       wp_header.end_date,
       wp_header.end_time,
       wp_header.description,
       wp_header.owner,
       wp_header.event_id,
       wp_header.astra_id,
       wp_header.paperwork_expected,
       wp_header.paperwork_del_date,
       wp_header.hangar,
       wp_header.hidden,
       wp_header.mutation,
       wp_header.mutator,
       wp_header.status,
       wp_header.mutation_time,
       wp_header.created_by,
       wp_header.created_date,
       wp_header.act_start_date,
       wp_header.act_start_time,
       wp_header.act_end_date,
       wp_header.act_end_time,
       wp_header.responsible,
       wp_header.delay,
       wp_header.non_routine_time,
       wp_header.engrun,
       wp_header.ratfunc,
       wp_header.acweigh,
       wp_header.ndt_req,
       wp_header.def_req,
       wp_header.jack_req,
       wp_header.change_eng1,
       wp_header.change_eng2,
       wp_header.change_apu,
       wp_header.borr_eng1,
       wp_header.borr_eng2,
       wp_header.borr_apu,
       wp_header.dirty_sequence,
       wp_header.handed_to_prod,
       wp_header.handed_to_prod_by,
       wp_header.handed_to_prod_to,
       wp_header.closing_date,
       wp_header.maintprov_address,
       wp_header.cust_wpno,
       wp_header.ops_status,
       wp_header.priority_code,
       wp_header.remarks,
       wp_header.amm_reference,
       wp_header.amm_publication_noi,
       wp_header.extension_time,
       wp_header.extension_reason,
       wp_header.mpno_i,
       wp_header.mp_revision,
       wp_header.wp_sequence_config_id,
       wp_header.sequence_on_assignment,
       wp_header.wp_status,
       wp_header.events_collection_status,
       wp_header.uuid,
       wp_header.flight_legno_i,
       wp_header.approvalno_i,
       wp_header.created_time
FROM wp_header
WHERE (wp_header.end_date >= 19090)
      AND wp_header.wp_status = -1
      AND (
         wp_header.ac_operator = 'VJC'
         AND wp_header.hidden = 'L'
         AND wp_header.wp_type = 0
      )
      AND wp_header.wp_type = 0  


-- Select WP no i  - Get detail infromation WP

SELECT wp_header.amm_oem_noi,
       wp_header.handed_to_prod_group,
       wp_header.mp_order_detailno_i,
       wp_header.target_end_time,
       wp_header.target_start_time,
       wp_header.return_type,
       wp_header.target_start_date,
       wp_header.est_end_time,
       wp_header.est_end_date,
       wp_header.est_start_time,
       wp_header.est_start_date,
       wp_header.comp_owner,
       wp_header.rc_order_detailno_i,
       wp_header.r_order_detailno_i,
       wp_header.use_new_certificates,
       wp_header.shop_arrival_time,
       wp_header.shop_arrival_date,
       wp_header.partially_imported,
       wp_header.esign_manually_set,
       wp_header.esign_policy,
       wp_header.req_condition,
       wp_header.part_description,
       wp_header.lm_groundtimeno_i,
       wp_header.inbound_scheduled_time,
       wp_header.inbound_scheduled_date,
       wp_header.departure_fltno,
       wp_header.is_imported,
       wp_header.ac_operator,
       wp_header.ac_model,
       wp_header.ac_subtype,
       wp_header.contact_person,
       wp_header.shop,
       wp_header.target_end_date,
       wp_header.partno,
       wp_header.next_flight_legno_i,
       wp_header.mpno,
       wp_header.engines_apu_serial,
       wp_header.test_flight,
       wp_header.cust_address,
       wp_header.auto_generated,
       wp_header.jobcards_collection_status,
       wp_header.internal_remarks,
       wp_header.quotationno_i,
       wp_header.wp_type,
       wp_header.drop_locationno_i,
       wp_header.wpno_i,
       wp_header.wpno,
       wp_header.ac_registr,
       wp_header.ac_typ,
       wp_header.projectno,
       wp_header.est_groundtime,
       wp_header.station,
       wp_header.start_date,
       wp_header.start_time,
       wp_header.arrival_fltno,
       wp_header.end_date,
       wp_header.end_time,
       wp_header.description,
       wp_header.owner,
       wp_header.event_id,
       wp_header.astra_id,
       wp_header.paperwork_expected,
       wp_header.paperwork_del_date,
       wp_header.hangar,
       wp_header.hidden,
       wp_header.mutation,
       wp_header.mutator,
       wp_header.status,
       wp_header.mutation_time,
       wp_header.created_by,
       wp_header.created_date,
       wp_header.act_start_date,
       wp_header.act_start_time,
       wp_header.act_end_date,
       wp_header.act_end_time,
       wp_header.responsible,
       wp_header.delay,
       wp_header.non_routine_time,
       wp_header.engrun,
       wp_header.ratfunc,
       wp_header.acweigh,
       wp_header.ndt_req,
       wp_header.def_req,
       wp_header.jack_req,
       wp_header.change_eng1,
       wp_header.change_eng2,
       wp_header.change_apu,
       wp_header.borr_eng1,
       wp_header.borr_eng2,
       wp_header.borr_apu,
       wp_header.dirty_sequence,
       wp_header.handed_to_prod,
       wp_header.handed_to_prod_by,
       wp_header.handed_to_prod_to,
       wp_header.closing_date,
       wp_header.maintprov_address,
       wp_header.cust_wpno,
       wp_header.ops_status,
       wp_header.priority_code,
       wp_header.remarks,
       wp_header.amm_reference,
       wp_header.amm_publication_noi,
       wp_header.extension_time,
       wp_header.extension_reason,
       wp_header.mpno_i,
       wp_header.mp_revision,
       wp_header.wp_sequence_config_id,
       wp_header.sequence_on_assignment,
       wp_header.wp_status,
       wp_header.events_collection_status,
       wp_header.uuid,
       wp_header.flight_legno_i,
       wp_header.approvalno_i,
       wp_header.created_time
FROM wp_header
WHERE wp_header.wpno_i = 34836  


-- Link

SELECT msc_mp_link.mp_linkno_i,
       msc_mp_link.mpno_i_requirement,
       msc_mp_link.mpno_i_operator,
       msc_mp_link.mutation,
       msc_mp_link.mutator,
       msc_mp_link.status,
       msc_mp_link.mutation_time,
       msc_mp_link.created_by,
       msc_mp_link.created_date
FROM msc_maintenance_program
JOIN msc_mp_link ON msc_maintenance_program.mpno_i = msc_mp_link.mpno_i_operator
JOIN msc_ac_configuration ON msc_maintenance_program.mpno_i = msc_ac_configuration.mpno_i
WHERE msc_maintenance_program.program_type = 'OMP'
      AND msc_ac_configuration.program_type = 'OMP'
      AND msc_ac_configuration.aircraftno_i = 1543
      AND msc_maintenance_program.operated_by = 'VJC'
      AND msc_mp_link.mpno_i_requirement <> -11
      AND msc_ac_configuration.status = 0  


--- Get APU, ENGINE 

SELECT rotables.partno,
       rotables.serialno,
       rotables.location,
       part_special.special
FROM rotables
JOIN part_special ON rotables.partno = part_special.partno
WHERE rotables.ac_registr = 'A521'
      AND part_special.special IN (
         'ENGINE',
         'APU'
      )
ORDER BY part_special.special,
         rotables.serialno NULLS FIRST  


-- Get priority
SELECT wp_priority_codes.type,
       wp_priority_codes.priority,
       wp_priority_codes.description,
       wp_priority_codes.mimetype
FROM wp_priority_codes  


---  Lấy danh sách các task trong WP 

-- get cols = wpno_i,ac_registr, event_type , event_perfno_i, event_display, prio
SELECT forecast.ext_workorderno,
       forecast.last_calculation_time,
       forecast.last_calculation_date,
       forecast.togo_neg_tol,
       forecast.togo_pos_tol,
       forecast.expected_time_neg_tol,
       forecast.expected_date_neg_tol,
       forecast.expected_time_pos_tol,
       forecast.expected_date_pos_tol,
       forecast.highest_psn,
       forecast.shop_doc,
       forecast.main_comp_psn,
       forecast.cust_event_no,
       forecast.campaign_schedule,
       forecast.campaign_applicable,
       forecast.campaign_plan,
       forecast.campaign_perf,
       forecast.planned_interval_usage,
       forecast.planner_relevant,
       forecast.project_number,
       forecast.executable,
       forecast.part_req_state,
       forecast.sequence,
       forecast.next_revision_status,
       forecast.next_revision_number,
       forecast.revision_status,
       forecast.revision_number,
       forecast.outdated_since_time,
       forecast.outdated_since_date,
       forecast.part_req_calc_status,
       forecast.mevt_headerno_i,
       forecast.taskcard_area,
       forecast.taskcard_zone,
       forecast.taskcard_cp_seq_code,
       forecast.taskcard_type_code,
       forecast.partno,
       forecast.serialno,
       forecast.ac_registr,
       forecast.ac_typ,
       forecast.sortitem,
       forecast.event,
       forecast.event_type,
       forecast.unique_key2,
       forecast.requirement,
       forecast.dimension,
       forecast.interval_dimension,
       forecast.interval_dimension_type,
       forecast.togo,
       forecast.since_req,
       forecast.absolute_due_at_ac,
       forecast.relative_due_at,
       forecast.interval_value,
       forecast.counter_defno_i,
       forecast.ref_date,
       forecast.expected_date,
       forecast.expected_time,
       forecast.expected_date_pln,
       forecast.expected_time_pln,
       forecast.date_planned,
       forecast.planned_time,
       forecast.togo_pln,
       forecast.wpno_i,
       forecast.event_perfno_i,
       forecast.workorderno_display,
       forecast.psn,
       forecast.removal_psn,
       forecast.removal_event_perfno_i,
       forecast.event_display,
       forecast.sched_unsched,
       forecast.est_mh,
       forecast.est_mhrs_linked,
       forecast.est_groundtime,
       forecast.work_type,
       forecast.pickslipno,
       forecast.prio,
       forecast.feedback_req,
       forecast.special_flags,
       forecast.pool_ac,
       forecast.station,
       forecast.interpolation,
       forecast.first_later_logic,
       forecast.mutation,
       forecast.absolute_due_at_ac_pln,
       forecast.remarks,
       forecast.interval_accuracy,
       forecast.mutator,
       forecast.status,
       forecast.mutation_time,
       forecast.created_by,
       forecast.created_date,
       forecast.ac_location,
       forecast.part_req_status,
       forecast.calculation_status
FROM forecast
JOIN wp_assignment ON forecast.event_perfno_i = wp_assignment.event_perfno_i AND (wp_assignment.wpno_i = 34836)  
-------------------

--
-- GET DATA - Lấy danh sách các task trong WP

SELECT 
    wp_header.wpno_i,
    wp_header.ac_registr,
    wp_header.station,
    wp_header.start_date,
    wp_header.end_date,
    wp_header.start_time,
    wp_header.end_time,
    wp_header.description,
    wp_header.internal_remarks
FROM wp_header
WHERE 
    (wp_header.end_date >= 19090) AND 
    wp_header.wp_status = -1 AND 
    (
        wp_header.ac_operator = 'VJC' AND 
        wp_header.hidden = 'L' AND 
        wp_header.wp_type = 0
    ) AND 
    wp_header.wp_type = 0;

SELECT 
    forecast.wpno_i,
    forecast.ac_registr,
    forecast.event_type,
    forecast.event_perfno_i,
    forecast.event_display,
    forecast.prio
FROM forecast
JOIN wp_assignment ON forecast.event_perfno_i = wp_assignment.event_perfno_i AND wp_assignment.wpno_i = 34836;

---
-- LẤY DANH SÁCH CÁC TASK TRONG DANH SÁCH WP
SELECT 
    forecast.*
FROM 
    forecast
JOIN 
    wp_header ON wp_header.wpno_i = forecast.wpno_i
WHERE 
    (wp_header.end_date >= 19090) AND 
    wp_header.wp_status = -1 AND 
    (
        wp_header.ac_operator = 'VJC' AND 
        wp_header.hidden = 'L' AND 
        wp_header.wp_type = 0
    ) AND 
    wp_header.wp_type = 0;

-- 
SELECT          
    forecast.wpno_i,
    forecast.ac_registr,
    wp_header.station,
    wp_header.start_time,
    wp_header.end_time,
    forecast.event_type,
    forecast.event_perfno_i,
    forecast.event_display,
    forecast.prio


FROM      forecast  
JOIN      wp_header ON wp_header.wpno_i = forecast.wpno_i  
WHERE      (wp_header.end_date >= 19090)        
      AND      wp_header.wp_status = -1        
      AND      (
         wp_header.ac_operator = 'VJC'           
         AND          wp_header.hidden = 'L'           
         AND          wp_header.wp_type = 0            
      )        
      AND      wp_header.wp_type = 0;

-- PRODUCTION SITE

-- PRODUCTION SITE - Deferred 

SELECT wo_transfer.wpno_i,
       wo_transfer.treq_dimension_groupno_i,
       wo_transfer.defer,
       wo_transfer.treq_interval_groupno_i,
       wo_transfer.event_perfno_i,
       wo_transfer.recno,
       wo_transfer.actionno_i,
       wo_transfer.first_later_logic,
       wo_transfer.is_last_transfer,
       wo_transfer.transfer_type,
       wo_transfer.transfer_station,
       wo_transfer.mech_sign,
       wo_transfer.user_sign,
       wo_transfer.remarks,
       wo_transfer.reason_code,
       wo_transfer.reason,
       wo_transfer.authorised_by,
       wo_transfer.transfer_time,
       wo_transfer.rts_date,
       wo_transfer.rts_time,
       wo_transfer.rts_sign,
       wo_transfer.rts_approval_number,
       wo_transfer.rts_approvalno_i,
       wo_transfer.rts_reference,
       wo_transfer.rts_type,
       wo_transfer.date_transfer,
       wo_transfer.rts_station,
       wo_transfer.transfer_hours,
       wo_transfer.transfer_cycles,
       wo_transfer.transfer_days,
       wo_transfer.doc_ref,
       wo_transfer.mutation,
       wo_transfer.mutator,
       wo_transfer.status,
       wo_transfer.mutation_time,
       wo_transfer.created_by,
       wo_transfer.created_date,
       wo_transfer.legno_i,
       wo_transfer.event_transferno_i,
       wo_transfer.limit_type,
       wo_transfer.uuid,
       wo_transfer.dc_use_case,
       wo_transfer.transfer_context,
       wo_transfer.init_option,
       wo_transfer.absolute_due_date,
       wo_transfer.absolute_due_time,
       wo_transfer.baseline_time,
       wo_transfer.baseline_date
FROM wo_transfer
WHERE wo_transfer.event_perfno_i = 10002352  


-- Lấy danh sách các task trong production
SELECT wp_history.wt_revision_date,
       wp_history.wt_revision_number,
       wp_history.taskcard_type,
       wp_history.action_type,
       wp_history.storage_id,
       wp_history.wp_groupno_i,
       wp_history.action_reason,
       wp_history.action_date,
       wp_history.action_time,
       wp_history.event_name,
       wp_history.event_perfno_i,
       wp_history.event_type,
       wp_history.remarks,
       wp_history.user_sign,
       wp_history.wp_seqno,
       wp_history.wpno_i,
       wp_history.wp_historyno_i,
       wp_history.mutation,
       wp_history.mutator,

       wp_history.status,
       wp_history.mutation_time,
       wp_history.created_by,
       wp_history.created_date,
       wp_history.created_time
FROM wp_history
WHERE wp_history.wpno_i = 34837  


-- PRODUCTION SITE - Closed

SELECT wo_header_4.event_perfno_i,
       wo_header_4.chk_acars,
       wo_header_4.event_type_mandatory,
       wo_header_4.mutation,
       wo_header_4.mutator,
       wo_header_4.status,
       wo_header_4.mutation_time,
       wo_header_4.created_by,
       wo_header_4.created_date,
       wo_header_4.mel_detailno_i,
       wo_header_4.chk_maint_procedure,
       wo_header_4.chk_ramp,
       wo_header_4.chk_not_contracted,
       wo_header_4.chk_telex,
       wo_header_4.chk_watch_item,
       wo_header_4.chk_ops_consequence,
       wo_header_4.customer_approval_req,
       wo_header_4.customer_acknowledgement,
       wo_header_4.customer_remarks,
       wo_header_4.event_classification,
       wo_header_4.ops_proc_req,
       wo_header_4.mel_sla,
       wo_header_4.cost_type,
       wo_header_4.costcenter
FROM wo_header_4
WHERE wo_header_4.event_perfno_i IN (
         4314931,
         5596742,
         5375823
      )  


--- PRODUCTION SITE - Get remark of WO

SELECT wo_remarks.event_perfno_i,
       wo_remarks.recordno,
       wo_remarks.recno,
       wo_remarks.text,
       wo_remarks.mutation,
       wo_remarks.mutator,
       wo_remarks.status,
       wo_remarks.mutation_time,
       wo_remarks.created_by,
       wo_remarks.created_date
FROM wo_remarks
WHERE wo_remarks.event_perfno_i IN (
         4314931,
         5596742,
         5375823
      )  


--- PRODUCTION SITE - Get all action taken of WO in WP

SELECT wo_text_action.crom_nodeno_i,
       wo_text_action.actionno_i,
       wo_text_action.event_perfno_i,
       wo_text_action.header,
       wo_text_action.text,
       wo_text_action.action_comment,
       wo_text_action.action_date,
       wo_text_action.action_time,
       wo_text_action.sign_performed,
       wo_text_action.sign_inspected,
       wo_text_action.sign_double_inspected,
       wo_text_action.mutation,
       wo_text_action.mutator,
       wo_text_action.status,
       wo_text_action.mutation_time,
       wo_text_action.created_by,
       wo_text_action.created_date,
       wo_text_action.created_time,
       wo_text_action.parent_actionno_i,
       wo_text_action.action_typeno_i,
       wo_text_action.workstep_linkno_i,
       wo_text_action.uuid,
       wo_text_action.wpno_i
FROM wo_text_action
WHERE wo_text_action.event_perfno_i IN (
         10002361,
         5235998,
         4314931,
         5596742,
         5681202,
         10002352,
         5375823,
         10002359
      )  