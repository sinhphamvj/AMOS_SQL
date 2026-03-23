# 📊 Query Table & Column Usage Analysis

Phân tích từ **131** file SQL trong các thư mục con.

## 📋 Top Tables (theo tần suất sử dụng)

| Table | Số lần sử dụng |
|-------|----------------|
| `wo_header` | 140 |
| `sign` | 109 |
| `wp_header` | 93 |
| `workstep_link` | 73 |
| `wo_text_description` | 65 |
| `address` | 61 |
| `wp_assignment` | 51 |
| `wo_header_more` | 44 |
| `event_template` | 41 |
| `rm_resource_request` | 32 |
| `rm_resource_requirement` | 32 |
| `rm_resource_constraint` | 32 |
| `rm_property_type` | 32 |
| `moc_daily_records` | 31 |
| `wp_content` | 30 |
| `work_template` | 28 |
| `bohi_version` | 24 |
| `bohi_changes` | 24 |
| `sp_user_availability` | 24 |
| `db_link` | 22 |
| `staff_pqs_qualification` | 21 |
| `sp_shift` | 21 |
| `CURRENT_TIME` | 20 |
| `với` | 18 |
| `staff_pqs_type` | 14 |
| `wo_transfer` | 13 |
| `limitation_config` | 13 |
| `wo_transfer_dimension` | 12 |
| `counter` | 12 |
| `counter_template` | 12 |

## 📊 Top Tables với nhiều columns được sử dụng

| Table | Số columns | Top Columns |
|-------|------------|-------------|
| `wp_header` | 114 | `ac_typ`, `dirty_sequence`, `def_req`, `req_condition`, `engines_apu_serial`, `ac_registr`, `act_start_date`, `remarks`, `inbound_scheduled_date`, `est_start_time` |
| `forecast` | 93 | `outdated_since_time`, `sortitem`, `highest_psn`, `ac_typ`, `next_revision_status`, `pool_ac`, `ac_registr`, `expected_date_pos_tol`, `remarks`, `removal_psn` |
| `part_forecast` | 83 | `reorder_level`, `event_ata`, `total_req_station_qty`, `accessable_station_qty`, `wpno`, `pickslip_snatched_qty`, `mutation`, `last_calculation_time`, `wp_type`, `part_request_mutation_date` |
| `wo_transfer` | 48 | `first_later_logic`, `doc_ref`, `rts_reference`, `baseline_date`, `treq_dimension_groupno_i`, `mutation_time`, `remarks`, `defer`, `mech_sign`, `reason_code` |
| `address` | 33 | `mutation_time`, `remarks`, `created_date`, `vendor`, `status`, `mutation`, `type_i`, `parent`, `bill_text`, `address_i` |
| `forecast_dimension` | 32 | `expected_date_pln`, `absolute_due_at_ac_pln`, `since_req`, `expected_date_pos_tol`, `interpolation`, `mutation_time`, `expected_time_neg_tol`, `ref_date`, `togo_pln`, `created_date` |
| `wo_header_4` | 24 | `customer_approval_req`, `mutation_time`, `chk_watch_item`, `mel_detailno_i`, `created_date`, `mutation`, `status`, `mel_sla`, `customer_acknowledgement`, `customer_remarks` |
| `wp_history` | 24 | `wp_groupno_i`, `action_reason`, `mutation_time`, `remarks`, `event_name`, `action_time`, `created_date`, `mutation`, `status`, `wt_revision_date` |
| `wo_text_action` | 23 | `parent_actionno_i`, `mutation_time`, `workstep_linkno_i`, `created_date`, `sign_inspected`, `mutation`, `status`, `actionno_i`, `sign_double_inspected`, `wpno_i` |
| `pickslip_detail` | 23 | `date_booked`, `mutation_time`, `workscope_i`, `qty_sys`, `created_date`, `oddetailno_i`, `mutation`, `progress_status`, `status`, `pma_status` |
| `rotables` | 21 | `owner`, `ac_registr`, `location`, `locationno_i`, `orderno`, `labelno`, `projectno_i`, `is_managed`, `pma`, `rec_detailno_i` |
| `part_request_2` | 21 | `percentage`, `initial_qty`, `loc_id_pk`, `mutation_time`, `qty`, `confirmed_qty`, `externally_provisioned`, `created_date`, `mutation`, `status` |
| `aircraft` | 20 | `owner`, `manufacturer`, `ac_typ`, `init_status`, `aircraftno_i`, `asset_owner`, `ac_registr`, `ac_subtype`, `is_mod_controlled`, `description` |
| `approval_document` | 20 | `due_date`, `document_handle`, `mutation_time`, `approval_documentno_i`, `request_date`, `document_owner`, `created_date`, `mutation`, `status`, `requested_by` |
| `wo_header` | 19 | `type`, `ac_registr`, `ata_chapter`, `mech_sign`, `issue_date`, `prio`, `template_revisionno_i`, `projectno`, `closing_date`, `release_time` |
| `ac_utilization` | 19 | `daily_cycles`, `tac`, `sched_departure_date`, `ac_registr`, `arrival`, `validity`, `leg_number`, `departure_time`, `status`, `null_leg_commited` |
| `pickslip_header` | 15 | `issue_date`, `station_to`, `status`, `event_key`, `station_from`, `created_date`, `remarks`, `store_to`, `pickslip_date`, `event_type` |
| `valid_staff` | 14 | `mech_stamp`, `employee_no_i`, `system`, `ac_type`, `notes`, `limitation`, `lastname`, `auth_number`, `firstname`, `expiry_date` |
| `s` | 14 | `mech_stamp`, `employee_no_i`, `status`, `lastname`, `auth_number`, `department`, `end_date`, `firstname`, `start_date`, `employee_no` |
| `adr_details` | 14 | `country`, `city`, `status`, `mutator`, `zip_code`, `mutation`, `address`, `created_by`, `mutation_time`, `address_1` |

## 🔍 Chi tiết Columns theo Table

### `wp_header` (114 columns)

| `ac_model` | `ac_operator` | `ac_registr` | `ac_subtype` | `ac_typ` |
| `act_end_date` | `act_end_time` | `act_start_date` | `act_start_time` | `acweigh` |
| `amm_oem_noi` | `amm_publication_noi` | `amm_reference` | `approvalno_i` | `arrival_fltno` |
| `astra_id` | `auto_generated` | `borr_apu` | `borr_eng1` | `borr_eng2` |
| `change_apu` | `change_eng1` | `change_eng2` | `closing_date` | `comp_owner` |
| `contact_person` | `created_by` | `created_date` | `created_time` | `cust_address` |
| `cust_wpno` | `def_req` | `delay` | `departure_fltno` | `description` |
| `dirty_sequence` | `drop_locationno_i` | `end_date` | `end_time` | `engines_apu_serial` |
| `engrun` | `esign_manually_set` | `esign_policy` | `est_end_date` | `est_end_time` |
| `est_groundtime` | `est_start_date` | `est_start_time` | `event_id` | `events_collection_status` |
| `extension_reason` | `extension_time` | `flight_legno_i` | `handed_to_prod` | `handed_to_prod_by` |
| `handed_to_prod_group` | `handed_to_prod_to` | `hangar` | `hidden` | `inbound_scheduled_date` |
| `inbound_scheduled_time` | `internal_remarks` | `is_imported` | `jack_req` | `jobcards_collection_status` |
| `lm_groundtimeno_i` | `maintprov_address` | `mp_order_detailno_i` | `mp_revision` | `mpno` |
| `mpno_i` | `mutation` | `mutation_time` | `mutator` | `ndt_req` |
| `next_flight_legno_i` | `non_routine_time` | `ops_status` | `owner` | `paperwork_del_date` |
| `paperwork_expected` | `part_description` | `partially_imported` | `partno` | `priority_code` |
| `projectno` | `quotationno_i` | `r_order_detailno_i` | `ratfunc` | `rc_order_detailno_i` |
| `remarks` | `req_condition` | `responsible` | `return_type` | `sequence_on_assignment` |
| `shop` | `shop_arrival_date` | `shop_arrival_time` | `start_date` | `start_time` |
| `station` | `status` | `target_end_date` | `target_end_time` | `target_start_date` |
| `target_start_time` | `test_flight` | `use_new_certificates` | `uuid` | `wp_sequence_config_id` |
| `wp_status` | `wp_type` | `wpno` | `wpno_i` |

### `forecast` (93 columns)

| `absolute_due_at_ac` | `absolute_due_at_ac_pln` | `ac_location` | `ac_registr` | `ac_typ` |
| `calculation_status` | `campaign_applicable` | `campaign_perf` | `campaign_plan` | `campaign_schedule` |
| `counter_defno_i` | `created_by` | `created_date` | `cust_event_no` | `date_planned` |
| `dimension` | `est_groundtime` | `est_mh` | `est_mhrs_linked` | `event` |
| `event_display` | `event_perfno_i` | `event_type` | `executable` | `expected_date` |
| `expected_date_neg_tol` | `expected_date_pln` | `expected_date_pos_tol` | `expected_time` | `expected_time_neg_tol` |
| `expected_time_pln` | `expected_time_pos_tol` | `ext_workorderno` | `feedback_req` | `first_later_logic` |
| `highest_psn` | `interpolation` | `interval_accuracy` | `interval_dimension` | `interval_dimension_type` |
| `interval_value` | `last_calculation_date` | `last_calculation_time` | `main_comp_psn` | `mevt_headerno_i` |
| `mutation` | `mutation_time` | `mutator` | `next_revision_number` | `next_revision_status` |
| `outdated_since_date` | `outdated_since_time` | `part_req_calc_status` | `part_req_state` | `part_req_status` |
| `partno` | `pickslipno` | `planned_interval_usage` | `planned_time` | `planner_relevant` |
| `pool_ac` | `prio` | `project_number` | `psn` | `ref_date` |
| `relative_due_at` | `remarks` | `removal_event_perfno_i` | `removal_psn` | `requirement` |
| `revision_number` | `revision_status` | `sched_unsched` | `sequence` | `serialno` |
| `shop_doc` | `since_req` | `sortitem` | `special_flags` | `station` |
| `status` | `taskcard_area` | `taskcard_cp_seq_code` | `taskcard_type_code` | `taskcard_zone` |
| `togo` | `togo_neg_tol` | `togo_pln` | `togo_pos_tol` | `unique_key2` |
| `work_type` | `workorderno_display` | `wpno_i` |

### `part_forecast` (83 columns)

| `accessable_station_qty` | `accessable_system_qty` | `availability_status` | `available_order_qty` | `best_order_date` |
| `best_order_date_type` | `calc_status` | `created_by` | `created_date` | `display_event_key` |
| `display_event_type` | `error_code` | `event_ata` | `event_display` | `event_key` |
| `event_perfno_i` | `event_type` | `expected_date` | `expected_time` | `ext_availability_mod_status` |
| `ext_transfer_mod_status` | `external_availability_status` | `external_transfer_status` | `inaccessable_station_qty` | `inaccessable_system_qty` |
| `ipc_reference` | `last_calculation_date` | `last_calculation_time` | `lead_time` | `mat_class` |
| `measure_unit` | `mutation` | `mutation_time` | `mutator` | `order_issue_date` |
| `part_ata_chapter` | `part_description` | `part_request_created_date` | `part_request_flags` | `part_request_mutation_date` |
| `part_request_part_cond` | `part_requestno_i` | `part_special_types` | `partno` | `percentage` |
| `pickslip_confirmed_qty` | `pickslip_requested_qty` | `pickslip_snatched_qty` | `planned_date` | `planned_station` |
| `planned_time` | `pre_allocated` | `prio` | `projectno` | `recalculation_trigger_date` |
| `recalculation_trigger_time` | `receiver` | `receiver_type` | `reorder_level` | `repairable` |
| `requested_qty` | `sched_unsched` | `special_flags` | `status` | `tool` |
| `total_confirmed_order_qty` | `total_order_qty` | `total_req_station_qty` | `total_requested_qty` | `total_reserved_order_qty` |
| `transfer_confirmed_qty` | `transfer_issue_date` | `transfer_qty` | `transfer_requested_qty` | `transfer_status` |
| `unavailable_order_qty` | `valid_due_date` | `valid_due_time` | `wp_drop_locationno_i` | `wp_status` |
| `wp_type` | `wpno` | `wpno_i` |

### `wo_transfer` (48 columns)

| `absolute_due_date` | `absolute_due_time` | `actionno_i` | `authorised_by` | `baseline_date` |
| `baseline_time` | `created_by` | `created_date` | `date_transfer` | `dc_use_case` |
| `defer` | `doc_ref` | `event_perfno_i` | `event_transferno_i` | `first_later_logic` |
| `init_option` | `is_last_transfer` | `legno_i` | `limit_type` | `mech_sign` |
| `mutation` | `mutation_time` | `mutator` | `reason` | `reason_code` |
| `recno` | `remarks` | `rts_approval_number` | `rts_approvalno_i` | `rts_date` |
| `rts_reference` | `rts_sign` | `rts_station` | `rts_time` | `rts_type` |
| `status` | `transfer_context` | `transfer_cycles` | `transfer_days` | `transfer_hours` |
| `transfer_station` | `transfer_time` | `transfer_type` | `treq_dimension_groupno_i` | `treq_interval_groupno_i` |
| `user_sign` | `uuid` | `wpno_i` |

### `address` (33 columns)

| `address_i` | `bill_payment_cond` | `bill_text` | `black_list` | `black_list_since` |
| `black_list_text` | `contact_name` | `costcenter` | `created_by` | `created_date` |
| `currency` | `default_tax_code` | `deliverycondition` | `discount` | `homebase` |
| `incomingincoterm` | `linked_adr` | `linked_detail` | `mutation` | `mutation_time` |
| `mutator` | `name` | `name_1` | `name_2` | `parent` |
| `paymentcondition` | `remarks` | `resource_type_id` | `ship_via` | `shipment` |
| `status` | `type_i` | `vendor` |

### `forecast_dimension` (32 columns)

| `absolute_due_at_ac` | `absolute_due_at_ac_pln` | `counter_defno_i` | `created_by` | `created_date` |
| `dimension` | `event_perfno_i` | `expected_date` | `expected_date_neg_tol` | `expected_date_pln` |
| `expected_date_pos_tol` | `expected_time` | `expected_time_neg_tol` | `expected_time_pln` | `expected_time_pos_tol` |
| `interpolation` | `interval_accuracy` | `interval_dimension` | `interval_dimension_type` | `interval_value` |
| `mutation` | `mutation_time` | `mutator` | `planned_interval_usage` | `ref_date` |
| `relative_due_at` | `since_req` | `status` | `togo` | `togo_neg_tol` |
| `togo_pln` | `togo_pos_tol` |

### `wo_header_4` (24 columns)

| `chk_acars` | `chk_maint_procedure` | `chk_not_contracted` | `chk_ops_consequence` | `chk_ramp` |
| `chk_telex` | `chk_watch_item` | `cost_type` | `costcenter` | `created_by` |
| `created_date` | `customer_acknowledgement` | `customer_approval_req` | `customer_remarks` | `event_classification` |
| `event_perfno_i` | `event_type_mandatory` | `mel_detailno_i` | `mel_sla` | `mutation` |
| `mutation_time` | `mutator` | `ops_proc_req` | `status` |

### `wp_history` (24 columns)

| `action_date` | `action_reason` | `action_time` | `action_type` | `created_by` |
| `created_date` | `created_time` | `event_name` | `event_perfno_i` | `event_type` |
| `mutation` | `mutation_time` | `mutator` | `remarks` | `status` |
| `storage_id` | `taskcard_type` | `user_sign` | `wp_groupno_i` | `wp_historyno_i` |
| `wp_seqno` | `wpno_i` | `wt_revision_date` | `wt_revision_number` |

### `wo_text_action` (23 columns)

| `action_comment` | `action_date` | `action_time` | `action_typeno_i` | `actionno_i` |
| `created_by` | `created_date` | `created_time` | `crom_nodeno_i` | `event_perfno_i` |
| `header` | `mutation` | `mutation_time` | `mutator` | `parent_actionno_i` |
| `sign_double_inspected` | `sign_inspected` | `sign_performed` | `status` | `text` |
| `uuid` | `workstep_linkno_i` | `wpno_i` |

### `pickslip_detail` (23 columns)

| `created_by` | `created_date` | `date_booked` | `event_perfno_i` | `expected_date` |
| `mutation` | `mutation_time` | `mutator` | `oddetailno_i` | `part_requestno_i` |
| `partno` | `pickslipno` | `pma_status` | `progress_status` | `qty_booked` |
| `qty_req` | `qty_sys` | `recno` | `repair_order` | `serialno` |
| `status` | `system_request` | `workscope_i` |

### `rotables` (21 columns)

| `ac_registr` | `condition` | `entityno_i` | `is_managed` | `labelno` |
| `linked_contract` | `location` | `locationno_i` | `material_lifecycle_id` | `orderno` |
| `owner` | `partno` | `partnonew` | `pma` | `projectno_i` |
| `psn` | `purch_recdetailno_i` | `rec_detailno_i` | `serialno` | `shelf_inspection_date` |
| `shelf_inspection_type` |

### `part_request_2` (21 columns)

| `confirmed_qty` | `created_by` | `created_date` | `event_key` | `event_type` |
| `externally_provisioned` | `initial_qty` | `loc_id_pk` | `mutation` | `mutation_time` |
| `mutator` | `no_pcf` | `parent_part_requestno_i` | `part_request_template_i` | `part_requestno_i` |
| `partno` | `percentage` | `qty` | `status` | `supply_in_time_status` |
| `uuid` |

### `aircraft` (20 columns)

| `ac_model` | `ac_registr` | `ac_subtype` | `ac_typ` | `aircraftno_i` |
| `asset_owner` | `auth_address_i` | `description` | `homebase` | `init_status` |
| `investigation` | `is_mod_controlled` | `maintenance_provider` | `manufacturer` | `non_managed` |
| `object_type` | `operator` | `owner` | `serialno` | `status` |

### `approval_document` (20 columns)

| `apn` | `approval_documentno_i` | `approval_state` | `approval_type` | `created_by` |
| `created_date` | `document_handle` | `document_key` | `document_owner` | `document_type` |
| `due_date` | `mutation` | `mutation_time` | `mutator` | `request_date` |
| `request_time` | `requested_by` | `rule_id` | `status` | `trigger_point` |

### `wo_header` (19 columns)

| `ac_registr` | `ata_chapter` | `closing_date` | `event_perfno_i` | `event_type` |
| `hil` | `issue_date` | `issue_station` | `mech_sign` | `mel_code` |
| `prio` | `projectno` | `psn` | `release_station` | `release_time` |
| `state` | `template_revisionno_i` | `type` | `workorderno_display` |

