SELECT c.partno,
          l.station,
          SUM(c.qty) AS total_qty,
        c.qty,
        c.locationno_i,
        c.batchno
    FROM consumables c
    JOIN location l ON c.locationno_i = l.locationno_i 

    WHERE 
       l.location_type <> -107
      AND l.location_type <> -3
      AND l.location_type <> -8
      AND c.condition <> `US`
      AND l.location_restriction = 0 and
 c.partno = '04-20004-0027'
    GROUP BY c.partno,
l.station,
c.qty,
c.locationno_i,
c.batchno