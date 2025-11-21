SELECT
    wh.event_perfno_i AS "WO",
    wh.ac_registr AS "AC_REG",
    TO_CHAR(DATE '1971-12-31' + wh.issue_date, 'DD.MON.YYYY') AS "ISSUE_DATE",
    TO_CHAR(DATE '1971-12-31' + MIN(fd.expected_date), 'DD.MON.YYYY') AS "DUE_DATE",

    MAX(CASE WHEN fd.dimension = 'D' THEN CAST(fd.togo / 1440 AS INT) END) AS "D-TOGO",
    MAX(CASE WHEN fd.dimension = 'H' THEN CAST(fd.togo / 60 AS INT) END) AS "H-TOGO",
    MAX(CASE WHEN fd.dimension = 'C' THEN CAST(fd.togo AS INT) END) AS "C-TOGO",

    wtd.header AS "DEFECT",
    wtd.text AS "ACTION_TAKEN",
       array_to_string(array_agg(wrm.text), E'\n') AS "REMARKS"

    
FROM
    wo_header AS wh
    LEFT JOIN workstep_link AS wl ON wh.event_perfno_i = wl.event_perfno_i
    LEFT JOIN wo_remarks AS wrm ON wh.event_perfno_i = wrm.event_perfno_i
    LEFT JOIN wo_text_description AS wtd ON wl.descno_i = wtd.descno_i
    LEFT JOIN forecast_dimension AS fd ON wh.event_perfno_i = fd.event_perfno_i

WHERE
    wh.event_perfno_i = @ADD7D_WO.WO@
    AND wl.sequenceno = 1

GROUP BY
    wh.event_perfno_i,
    wh.ac_registr,
    wh.issue_date,
    wtd.header,
    wtd.text

HAVING
    MAX(CASE WHEN fd.dimension = 'D' THEN CAST(fd.togo / 1440 AS INT) END) <= 7
    OR MAX(CASE WHEN fd.dimension = 'H' THEN CAST(fd.togo / 60 AS INT) END) <= 84
    OR MAX(CASE WHEN fd.dimension = 'C' THEN CAST(fd.togo AS INT) END) <= 42

ORDER BY
    "DUE_DATE" ASC