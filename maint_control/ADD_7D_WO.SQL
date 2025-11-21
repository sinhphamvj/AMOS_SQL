SELECT
    WO.event_perfno_i AS "WO"
FROM (
    SELECT
        wo_header.event_perfno_i,
        fd.expected_date,
        NULL AS misson_config_no_i,
        fd.dimension,
        fd.togo
    FROM
        wo_header
 FULL JOIN
        wo_header_4 ON wo_header.event_perfno_i = wo_header_4.event_perfno_i
    FULL JOIN
        forecast_dimension AS fd ON wo_header.event_perfno_i = fd.event_perfno_i
 FULL   JOIN
        aircraft ON wo_header.ac_registr = aircraft.ac_registr
 FULL   JOIN
        ac_mission ON aircraft.aircraftno_i = ac_mission.aircraftno_i
WHERE wo_header.event_perfno_i > 0
      AND wo_header.workorderno_display IS NOT NULL
      AND (
         wo_header.event_type NOT IN (
            'Q',
            'T'
         )
      )
      AND EXISTS (
         SELECT aircraft.ac_registr
         FROM aircraft
         WHERE wo_header.ac_registr = aircraft.ac_registr
               AND aircraft.ac_registr LIKE 'A%'
      )
      AND wo_header.type IN (
         'P',
         'M',
         'C',
         'S'
      )
      AND (wo_header_4.chk_watch_item = 'Y')
      AND wo_header.state = 'O'  
    
    UNION ALL
    
    SELECT
        wo_header.event_perfno_i,
        fd.expected_date,
        ac_mission.misson_config_no_i,
        fd.dimension,
        fd.togo
    FROM
        wo_header
    LEFT JOIN
        wo_header_more ON wo_header.event_perfno_i = wo_header_more.event_perfno_i
    LEFT JOIN
        forecast ON wo_header.event_perfno_i = forecast.event_perfno_i
    LEFT JOIN
        forecast_dimension AS fd ON wo_header.event_perfno_i = fd.event_perfno_i
    FULL JOIN
        aircraft ON wo_header.ac_registr = aircraft.ac_registr
    FULL JOIN
        ac_mission ON aircraft.aircraftno_i = ac_mission.aircraftno_i
    WHERE
        wo_header.event_perfno_i > 0
        AND wo_header.workorderno_display IS NOT NULL
        AND wo_header.event_type NOT IN ('Q', 'T')
        AND aircraft.ac_registr LIKE 'A%'
        AND wo_header.type IN ('M','P')
        AND wo_header.state = 'O'
        AND (ac_mission.misson_config_no_i <> 1001 OR ac_mission.misson_config_no_i IS NULL)
        
        AND forecast.event_display NOT LIKE '%/REPETITIVE INSPECTION FOR %'
      AND wo_header_more.wo_class IN  (
         'A',
         'L',
         'T'                                                        
      ) 
      AND wo_header_more.mel_chapter NOT LIKE '25-64-01%'           
) AS WO
GROUP BY WO.event_perfno_i
HAVING
    MAX(CASE WHEN WO.dimension = 'D' THEN CAST(WO.togo / 1440 AS INT) END) <= 7
    OR MAX(CASE WHEN WO.dimension = 'H' THEN CAST(WO.togo / 60 AS INT) END) <= 98
    OR MAX(CASE WHEN WO.dimension = 'C' THEN CAST(WO.togo AS INT) END) <= 56
ORDER BY MIN(WO.expected_date) ASC