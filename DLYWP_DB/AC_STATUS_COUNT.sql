SELECT 
    CASE
        WHEN moc_daily_records.event_type = 'AOG' THEN 'AOG'
        WHEN moc_daily_records.event_type = 'A_CHK' THEN 'A CHECK'
        WHEN moc_daily_records.event_type = 'C_CHK' THEN 'C CHECK'
        WHEN moc_daily_records.event_type = 'ST_MT' THEN 'STORAGE'
        WHEN moc_daily_records.event_type = 'PK_MT' THEN 'PARKING'
        WHEN moc_daily_records.event_type = 'O_CHK' THEN 'OTHER'
        WHEN moc_daily_records.event_type = 'COA' THEN 'COA'
        ELSE moc_daily_records.event_type
    END AS "TYPE",
    COUNT(*) AS "EVENT_COUNT"
FROM
    aircraft
LEFT JOIN
    moc_daily_records ON aircraft.ac_registr = moc_daily_records.ac_registr
WHERE
    aircraft.ac_registr LIKE 'A%'
    AND aircraft.operator = 'VJC'
    AND aircraft.non_managed = 'N'
    AND aircraft.ac_typ IN ('A330F', 'A321FL', 'A320')
    AND moc_daily_records.event_type IN ('AOG', 'ST_MT', 'PK_MT', 'A_CHK', 'O_CHK', 'C_CHK', 'COA')
    AND moc_daily_records.closed <> 'Y'
    AND moc_daily_records.event_group IN ('DLYRP') 
GROUP BY
    CASE
        WHEN moc_daily_records.event_type = 'AOG' THEN 'AOG'
        WHEN moc_daily_records.event_type = 'A_CHK' THEN 'A CHECK'
        WHEN moc_daily_records.event_type = 'C_CHK' THEN 'C CHECK'
        WHEN moc_daily_records.event_type = 'ST_MT' THEN 'STORAGE'
        WHEN moc_daily_records.event_type = 'PK_MT' THEN 'PARKING'
        WHEN moc_daily_records.event_type = 'O_CHK' THEN 'OTHER'
        WHEN moc_daily_records.event_type = 'COA' THEN 'COA'
        ELSE moc_daily_records.event_type
    END
ORDER BY
    MIN(CASE
        WHEN moc_daily_records.event_type = 'AOG' THEN 1
        WHEN moc_daily_records.event_type = 'C_CHK' THEN 2
        WHEN moc_daily_records.event_type = 'A_CHK' THEN 3
        WHEN moc_daily_records.event_type = 'O_CHK' THEN 4
        WHEN moc_daily_records.event_type = 'ST_MT' THEN 5
        WHEN moc_daily_records.event_type = 'PK_MT' THEN 6
        WHEN moc_daily_records.event_type = 'COA' THEN 7
        ELSE 8
    END)