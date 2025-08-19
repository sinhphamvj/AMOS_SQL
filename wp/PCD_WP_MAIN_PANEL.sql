SELECT
    wpno_i,
    wpno,
wp_status,
    ac_registr AS "AC_REG",
    station AS "STATION",
    TO_CHAR(DATE '1971-12-31' + start_date, 'DD.MON.YYYY') AS "START_DATE",
    TO_CHAR(TIME '00:00' + (start_time || ' minutes')::interval, 'HH24:MI') AS "START_TIME",
    TO_CHAR(DATE '1971-12-31' + end_date, 'DD.MON.YYYY') AS "END_DATE",
    TO_CHAR(TIME '00:00' + (end_time || ' minutes')::interval, 'HH24:MI') AS "END_TIME",
    TO_CHAR(TIME '00:00' + (
        CASE 
            WHEN end_time < start_time THEN (end_time + 1440) - start_time
            ELSE end_time - start_time
        END || ' minutes')::interval, 'HH24:MI') AS "GROUND_TIME",
    remarks AS "REMARKS",
    engrun,
    jack_req,
    ndt_req,
    def_req,
    ratfunc,
    borr_eng1,
    borr_eng2,
    borr_apu,
    change_apu,
    change_eng1,
    change_eng2

FROM
    wp_header
WHERE
    wp_header.wpno_i IN (@PCD_WP_MAIN.wpno_i@)