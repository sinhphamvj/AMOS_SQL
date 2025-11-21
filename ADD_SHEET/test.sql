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
   
         wo_header.event_type NOT IN ('Q', 'T')
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
      AND wo_header_more.mel_chapter NOT LIKE '%25-64-01%'

GROUP BY wo_header.event_perfno_i,
 fd.expected_date,
        ac_mission.misson_config_no_i,
        fd.dimension,
        fd.togo
HAVING
    MAX(CASE WHEN fd.dimension = 'D' THEN CAST(fd.togo / 1440 AS INT) END) <= 7
    OR MAX(CASE WHEN fd.dimension = 'H' THEN CAST(fd.togo / 60 AS INT) END) <= 98
    OR MAX(CASE WHEN fd.dimension = 'C' THEN CAST(fd.togo AS INT) END) <= 56