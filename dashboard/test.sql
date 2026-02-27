SELECT DISTINCT ON (wh.event_perfno_i)
    CURRENT_TIMESTAMP AS timestamp,
    wh.event_perfno_i AS "WO Number",
    wh.ext_workorderno,
    wh.ac_registr AS "Aircraft Reg",
    wh.ata_chapter,
    -- Date conversions using NULLIF to prevent "date out of range" errors
    TO_CHAR(DATE `1971-12-31` + NULLIF(wh.issue_date, 0), `DD MON YYYY`) AS issue_date,
    CASE wh.mel_code WHEN `L` THEN `CDL` ELSE wh.mel_code END AS mel_code,
    whm.mel_chapter AS "MEL Chapter",
    CASE WHEN wtl.actionno_i = wta.actionno_i THEN `Yes` ELSE `No` END AS activeTransfer,
    ```` || REPLACE(wta.text, ````, `""`) || ```` AS act_text,
        s.firstname || ` ` || s.lastname AS Editor,
CASE
        WHEN COALESCE(wrl.has_doc_ref, 0) = 1 AND wta.text LIKE `%REFERENCE/REVISION:%` THEN `Updated`
        WHEN COALESCE(wrl.has_doc_ref, 0) = 1 AND NOT wta.text LIKE `%REFERENCE/REVISION:%` THEN `TBChecked`
        WHEN COALESCE(wrl.has_doc_ref, 0) = 0 AND wta.text LIKE `%REFERENCE/REVISION:%` THEN `Missing`
        ELSE `N/A` END AS "Doc_Ref",

    CASE
        WHEN COALESCE(wrl.has_mp, 0) = 1 AND wta.text LIKE `%MAINT PROC%` THEN `Updated`
        WHEN COALESCE(wrl.has_mp, 0) = 1 AND NOT wta.text LIKE `%MAINT PROC%` THEN `TBChecked`
        WHEN COALESCE(wrl.has_mp, 0) = 0 AND wta.text LIKE `%MAINT PROC%` THEN `Missing`
        ELSE `N/A` END AS "Main Proc",

    CASE
        WHEN COALESCE(wrl.has_ops, 0) = 1 AND wta.text LIKE `%OPS PROC%OPERATIONS PROCEDURE%` THEN `Updated`
        WHEN COALESCE(wrl.has_ops, 0) = 1 AND NOT wta.text LIKE `%OPS PROC%OPERATIONS PROCEDURE%` THEN `TBChecked`
        WHEN COALESCE(wrl.has_ops, 0) = 0 AND wta.text LIKE `%OPS PROC%OPERATIONS PROCEDURE%` THEN `Missing`
        ELSE `N/A` END AS "Ops Proc",

    CASE
        -- FIX APPLIED: Removed the extra THEN `Missing` clause
        WHEN (COALESCE(wrl.has_ops_limit, 0) = 1 AND wta.text LIKE `%OPS LIMIT%OPERATIONS LIMITATION%`) OR COALESCE(wh4.chk_ops_consequence, `N`) =`Y` THEN `Updated`
        WHEN (COALESCE(wrl.has_ops_limit, 0) = 0  AND COALESCE(wh4.chk_ops_consequence, `N`) =`N`) AND wta.text LIKE `%OPS LIMIT%OPERATIONS LIMITATION%` THEN `Missing`
        ELSE `N/A` END AS "Ops Limit",

    COALESCE(wh4.chk_ops_consequence, `N`) AS tf_chk_ops_consequence,
    wo.flt_deck_info,
    wo.cabin_info,
    whc.briefing_card,
    whc.feedback_req,
    whm.wo_class,
    whc.aog_risk,
    CASE wh.mel_code WHEN `L` THEN `CDL` WHEN `A` THEN `MEL` WHEN `B` THEN `MEL` WHEN `C` THEN `MEL` WHEN `D` THEN `MEL` ELSE `` END AS add_type

FROM wo_header wh
-- 1. Derived Table for WO_Transfer_Latest
LEFT JOIN (
    SELECT event_perfno_i, reason_code, actionno_i,
    ROW_NUMBER() OVER(PARTITION BY event_perfno_i ORDER BY recno DESC) AS rn
    FROM wo_transfer
) AS wtl ON wh.event_perfno_i = wtl.event_perfno_i AND wtl.rn = 1

-- 3. Derived Table for WO_Required_Links
LEFT JOIN (
    SELECT source_pk::INT AS event_perfno_i,
    MAX(CASE WHEN ref_type = `DOC_REF` THEN 1 ELSE 0 END) AS has_doc_ref,
    MAX(CASE WHEN ref_type = `MP` AND description LIKE `%Y%` THEN 1 ELSE 0 END) AS has_mp,
    MAX(CASE WHEN ref_type = `OPS` AND description LIKE `%Y%` THEN 1 ELSE 0 END) AS has_ops,
    MAX(CASE WHEN ref_type = `OPSLIMIT` AND description LIKE `%Y%` THEN 1 ELSE 0 END) AS has_ops_limit
    FROM db_link
    WHERE source_type = `WO`
    GROUP BY source_pk
) AS wrl ON wh.event_perfno_i = wrl.event_perfno_i

-- Remaining Standard Joins
LEFT JOIN wo_header_more whm ON wh.event_perfno_i = whm.event_perfno_i
LEFT JOIN wo_header_4 wh4 ON wh.event_perfno_i = wh4.event_perfno_i
LEFT JOIN wo_opus wo ON wh.event_perfno_i = wo.event_perfno_i
LEFT JOIN wo_header_crx whc ON wh.event_perfno_i = whc.event_perfno_i
LEFT JOIN workstep_link wsl ON wh.event_perfno_i = wsl.event_perfno_i
LEFT JOIN wo_text_description wtd ON wsl.descno_i = wtd.descno_i
LEFT JOIN wo_text_action wta ON wsl.workstep_linkno_i = wta.workstep_linkno_i AND wh.event_perfno_i = wta.event_perfno_i
LEFT JOIN sign s ON wta.sign_performed = s.user_sign

WHERE
    -- Step 1: List All Open Aircraft Defects
    wh.state = `O`
    -- Assuming the IN clause was for testing; I`ve commented it out to run the full filter logic:
    -- AND wh.event_perfno_i IN (5913160, 10350390) 
    AND whm.wo_class IN (`A`, `L`, `T`)
    AND (wh4.chk_ops_consequence = `Y` OR wh.hil = `Y` OR (wh.mel_code IS NOT NULL AND wh.mel_code <> `F`))

    -- Step 2: WO_TEXT_ACTION Filters (Combining REFERENCE/REVISION and %MAINT PROC%)
    AND wta.text IS NOT NULL
    -- The core logic: find WOs missing at least one required link.
    AND (
        (COALESCE(wrl.has_doc_ref, 0) = 0 AND wta.text LIKE `%REFERENCE/REVISION:%`)
        OR (COALESCE(wrl.has_mp, 0) = 0 AND wta.text LIKE `%MAINT PROC%`)
        OR (COALESCE(wrl.has_ops, 0) = 0 AND wta.text LIKE  `%OPS PROC%OPERATIONS PROCEDURE%`)
        OR ((COALESCE(wrl.has_ops_limit, 0) = 0 AND wta.text LIKE  `%OPS LIMIT%OPERATIONS LIMITATION%`) OR (COALESCE(wrl.has_doc_ref, 0) = 0 AND NOT wta.text LIKE  `%OPS LIMIT%OPERATIONS LIMITATION%` AND COALESCE(wh4.chk_ops_consequence, `N`) =`Y`))
    )
AND NOT wtd.text LIKE `%NOTE: THIS WORKORDER MUST BE ACTIONED IN ETLB ONLY. DO NOT CLOSE THIS WORKORDER.%`
    -- Ensure the aircraft belongs to the correct operator and is not a dummy record
    AND EXISTS (
        SELECT 1 FROM aircraft a WHERE a.ac_registr = wh.ac_registr AND a.ac_registr <> `DUMMY` AND a.operator = `VJC`
    )

ORDER BY
    wh.event_perfno_i,
    wsl.sequenceno,
    wta.actionno_i;