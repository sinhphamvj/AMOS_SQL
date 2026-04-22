SELECT 
       SUM(CASE WHEN location.station = 'SGN' AND r.condition IN ('US','S') THEN 1 ELSE 0 END) AS SGN_TOTAL,
       SUM(CASE WHEN location.station = 'SGN' AND r.condition = 'US'        THEN 1 ELSE 0 END) AS SGN_US,
       SUM(CASE WHEN location.station = 'SGN' AND r.condition = 'S'         THEN 1 ELSE 0 END) AS SGN_S,

       SUM(CASE WHEN location.station = 'HAN' AND r.condition IN ('US','S') THEN 1 ELSE 0 END) AS HAN_TOTAL,
       SUM(CASE WHEN location.station = 'HAN' AND r.condition = 'US'        THEN 1 ELSE 0 END) AS HAN_US,
       SUM(CASE WHEN location.station = 'HAN' AND r.condition = 'S'         THEN 1 ELSE 0 END) AS HAN_S,

       SUM(CASE WHEN location.station = 'DAD' AND r.condition IN ('US','S') THEN 1 ELSE 0 END) AS DAD_TOTAL,
       SUM(CASE WHEN location.station = 'DAD' AND r.condition = 'US'        THEN 1 ELSE 0 END) AS DAD_US,
       SUM(CASE WHEN location.station = 'DAD' AND r.condition = 'S'         THEN 1 ELSE 0 END) AS DAD_S,

       SUM(CASE WHEN location.station = 'CXR' AND r.condition IN ('US','S') THEN 1 ELSE 0 END) AS CXR_TOTAL,
       SUM(CASE WHEN location.station = 'CXR' AND r.condition = 'US'        THEN 1 ELSE 0 END) AS CXR_US,
       SUM(CASE WHEN location.station = 'CXR' AND r.condition = 'S'         THEN 1 ELSE 0 END) AS CXR_S
FROM rotables r
LEFT JOIN location ON r.locationno_i = location.locationno_i
WHERE r.partno IN ('GA100V12D2000','GA140V13','GA140V13-VJGS')
