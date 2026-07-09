SELECT
    actionno_i,
    ac_registr,
    wpno_i,
    user_department,
    "WO",
    user_sign,
    "start_date",
    start_time,
    "end_date",
    end_time,
    "used_MHR",
    "TOTAL_EST_MHR",
    description,
    wpno,
    ref_type,
    link_type,
    source_pk,
    source_type,
    created_by,
    created_date,
    header,
    text,
    "ACTION_TAKEN",
    "ACTION_TAKEN_HTML"

FROM (
    SELECT
        wta.actionno_i,
        time_captured_additional.ac_registr,
        time_captured_additional.wpno_i,
        time_captured_additional.user_department,
        time_captured.primkey AS "WO",
        time_captured.user_sign,
        TO_CHAR(DATE '1971-12-31' + time_captured.start_date, 'DD.Mon.YYYY') AS "start_date",
        time_captured.start_time,
        TO_CHAR(DATE '1971-12-31' + time_captured.end_date, 'DD.Mon.YYYY') AS "end_date",
        time_captured.end_time,
        time_captured.duration AS "used_MHR",
        (
            SELECT SUM(rreq_sub.total_hours)
            FROM rm_resource_requirement rreq_sub
            JOIN rm_resource_request rreq_inner ON rreq_sub.resource_request_noi = rreq_inner.resource_request_noi
            JOIN workstep_link ws_link_sub ON rreq_inner.request_owner_amos_key = ws_link_sub.descno_i
            LEFT JOIN rm_resource_constraint rc_sub ON rreq_sub.resource_requirement_noi = rc_sub.resource_requirement_noi
            LEFT JOIN rm_property_type rpt_sub ON rc_sub.property_type_no_i = rpt_sub.property_type_no_i
            WHERE ws_link_sub.event_perfno_i = time_captured.primkey
              AND rpt_sub.resource_category = 'STAFF'
        ) AS "TOTAL_EST_MHR",
        db_link.description,
        wp_header.wpno,
        db_link.ref_type,
        db_link.link_type,
        db_link.source_pk,
        db_link.source_type,
        wta.created_by,
        wta.created_date,
        wo_text_description.header,
        wta.text,
        wo_text_description.text AS "ACTION_TAKEN",
        wo_text_description.text_html AS "ACTION_TAKEN_HTML",
        -- Đánh số thứ tự: khi actionno_i NOT NULL thì dedup, giữ bản ghi sớm nhất
        CASE
            WHEN wta.actionno_i IS NOT NULL THEN
                ROW_NUMBER() OVER (
                    PARTITION BY wta.actionno_i
                    ORDER BY time_captured.start_date ASC, time_captured.start_time ASC
                )
            ELSE 1
        END AS rn

    FROM time_captured
    LEFT JOIN time_captured_additional ON time_captured_additional.bookingno_i = time_captured.bookingno_i
    LEFT JOIN wo_text_action wta ON time_captured_additional.itemno_i = wta.actionno_i
    LEFT JOIN db_link ON wta.actionno_i::VARCHAR = db_link.source_pk
        AND db_link.source_type = 'WOA'
    LEFT JOIN workstep_link ON workstep_link.workstep_linkno_i = wta.workstep_linkno_i
    LEFT JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
    LEFT JOIN wp_header ON wp_header.wpno_i = time_captured_additional.wpno_i
    WHERE time_captured.user_sign = 'VJC4679'
          AND time_captured.start_date >= 19912
          AND (db_link.ref_type IN ('WP','EPF','WO') OR (db_link.ref_type IS NULL AND time_captured_additional.wpno_i IS NOT NULL))
          AND (wta.actionno_i IS NULL OR wta.sign_performed = time_captured.user_sign)
          AND (
              db_link.ref_type <> 'WO'
              OR db_link.ref_type IS NULL
              OR (
                  db_link.description ~ '^[0-9]+$'
                  AND EXISTS (
                      SELECT 1
                      FROM workstep_link wsl_wo
                      JOIN wo_text_description wtd_wo ON wtd_wo.descno_i = wsl_wo.descno_i
                      WHERE wsl_wo.event_perfno_i = db_link.description::INTEGER
                        AND (wtd_wo.text LIKE '%PRE-FLIGHT CHECK%' OR wtd_wo.text LIKE '%DAILY CHECK%')
                  )
              )
          )
    GROUP BY
        wta.actionno_i,
        time_captured_additional.ac_registr,
        time_captured_additional.wpno_i,
        time_captured_additional.user_department,
        time_captured.primkey,
        time_captured.user_sign,
        time_captured.start_date,
        time_captured.start_time,
        time_captured.end_date,
        time_captured.end_time,
        time_captured.duration,
        db_link.description,
        db_link.ref_type,
        db_link.link_type,
        db_link.source_pk,
        wta.created_by,
        wta.created_date,
        wo_text_description.header,
        wo_text_description.text,
        wo_text_description.text_html,
        wta.text,
        db_link.source_type,
        wp_header.wpno
) base
WHERE rn = 1
