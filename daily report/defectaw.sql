SELECT
   wh.event_perfno_i AS "WO",
   wh.ac_registr AS "AC_REG",
   wh.ata_chapter AS "ATA",
   wh.mel_code AS "MEL",
   wtd.text
FROM
   wo_header as wh
   LEFT JOIN wo_header_more ON wh.event_perfno_i = wo_header_more.event_perfno_i
   LEFT JOIN workstep_link wl ON wh.event_perfno_i = wl.event_perfno_i
   LEFT JOIN wo_text_description wtd ON wl.descno_i = wtd.descno_i
WHERE
   wh.ac_registr LIKE 'A%'
   AND wh.type IN ('M', 'P')
   AND wo_header_more.wo_class = 'A'
   AND wh.state IN ('O', 'C')
   AND wh.issue_date >=18650
   AND wtd.text not LIKE 'REPETITIVE INSPECTION%'