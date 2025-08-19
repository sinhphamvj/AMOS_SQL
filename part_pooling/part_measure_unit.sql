SELECT part.measure_unit,
       measure_unit.description,
       1.0 AS Rate,
       part.measure_unit AS InternalUM,
       'Internal' AS IntExt
FROM part
JOIN measure_unit ON part.measure_unit = measure_unit.measure_unit
WHERE (part.partno = '6773F010000')
      AND part.measure_unit = 'EA'
UNION
SELECT um_conversion.measure_unit_ext,
       measure_unit.description,
       um_conversion.rate,
       um_conversion.measure_unit AS InternalUM,
       'External'
FROM um_conversion,
     measure_unit
WHERE um_conversion.status <> 9
      AND um_conversion.partno = '6773F010000'
      AND um_conversion.measure_unit_ext = measure_unit.measure_unit  