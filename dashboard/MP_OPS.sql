SELECT
   mp_query."MP",
   apu_query."APU",
   brake_query."BRAKE",
   cargo_query."CARGO",
   bleed_query."BLEED",
   edto_query."EDTO",
   wxr_query."WXR",
   satcom_query."SATCOM",
   normal_seat_query."NORMAL_SEAT",
   skyboss_seat_query."SKYBOSS_SEAT",
   lav_inop_query."LAV_INOP",
   others_query."OTHERS"
FROM
   -- Total number of MP events
   (
      SELECT
         COUNT(*) AS "MP"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i IN (136, 137, 339)
         AND wh.state = 'O'
   ) mp_query,
   -- Total number of APU events
   (
      SELECT
         COUNT(*) AS "APU"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i IN (23, 24, 25)
         AND wh.state = 'O'
   ) apu_query,
   -- Total number of BRAKE events
   (
      SELECT
         COUNT(*) AS "BRAKE"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 340
         AND wh.state = 'O'
   ) brake_query,
   -- Total number of CARGO events
   (
      SELECT
         COUNT(*) AS "CARGO"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 337
         AND wh.state = 'O'
   ) cargo_query,
   -- Total number of BLEED events
   (
      SELECT
         COUNT(*) AS "BLEED"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 336
         AND wh.state = 'O'
   ) bleed_query,
   -- Total number of EDTO events
   (
      SELECT
         COUNT(*) AS "EDTO"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 338
         AND wh.state = 'O'
   ) edto_query,
   -- Total number of WXR events
   (
      SELECT
         COUNT(*) AS "WXR"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 344
         AND wh.state = 'O'
   ) wxr_query,
   -- Total number of SATCOM events
   (
      SELECT
         COUNT(*) AS "SATCOM"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 343
         AND wh.state = 'O'
   ) satcom_query,
   -- Total number of NORMAL_SEAT events
   (
      SELECT
         COUNT(*) AS "NORMAL_SEAT"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 345
         AND wh.state = 'O'
   ) normal_seat_query,
   -- Total number of SKYBOSS_SEAT events
   (
      SELECT
         COUNT(*) AS "SKYBOSS_SEAT"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 346
         AND wh.state = 'O'
   ) skyboss_seat_query,
   -- Total number of LAV_INOP events
   (
      SELECT
         COUNT(*) AS "LAV_INOP"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 341
         AND wh.state = 'O'
   ) lav_inop_query,
   -- Total number of OTHERS events
   (
      SELECT
         COUNT(*) AS "OTHERS"
      FROM
         wo_header AS wh
         JOIN limitation_config AS lc ON lc.configuration_key = wh.event_perfno_i
      WHERE
         lc.limitation_typeno_i = 342
         AND wh.state = 'O'
   ) others_query