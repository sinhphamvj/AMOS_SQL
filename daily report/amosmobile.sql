SELECT
  wo_part_on_off.event_perfno_i,
  bohi_version.primkey,
  bohi_version.description,
  bohi_changes.action,
  bohi_changes.changes_date,
  TO_CHAR(
    DATE '1971-12-31' + bohi_changes.changes_date,
    'DD MON YYYY'
  ) AS ch_date,
  wo_header.release_station,
  sign.homebase,
  wo_part_on_off.status,
  wo_part_on_off.partno,
  wo_part_on_off.created_by
FROM
  bohi_version FULL
  JOIN bohi_changes ON bohi_version.versionno_i = bohi_changes.versionno_i FULL
  JOIN bohi_info ON bohi_info.changesno_i = bohi_changes.changesno_i FULL
  JOIN wo_part_on_off ON bohi_version.primkey = wo_part_on_off.event_perfno_i FULL
  JOIN sign ON wo_part_on_off.created_by = sign.user_sign FULL
  JOIN wo_header ON bohi_version.primkey = wo_header.event_perfno_i
WHERE
  bohi_changes.changes_date = 19293
  and bohi_changes.action like '%AMOSmobile%'