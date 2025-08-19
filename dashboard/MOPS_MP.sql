SELECT CAST(wo_header.event_perfno_i AS INT) AS "WO"
FROM wo_header
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
      AND (
         wo_header.mel_code IN (
            'A',
            'B',
            'C',
            'D',
            'L',
            'F'
         )
         OR wo_header.hil = 'Y'
      )
      AND (
         EXISTS (
            SELECT limitation_config.limitation_typeno_i
            FROM limitation_config
            WHERE limitation_config.mime_type = 'WO'
                  AND limitation_config.configuration_key = wo_header.event_perfno_i
                  AND limitation_config.limitation_typeno_i IN (
                     136,
                     137,
                     339
                  )
         )
      )
      AND wo_header.state = 'O'