SELECT 
    MAX(CASE 
            WHEN forecast_dimension.dimension = 'C' 
            THEN forecast_dimension.absolute_due_at_ac::INT 
        END) AS due_TAC,

    MAX(CASE 
            WHEN forecast_dimension.dimension = 'H' 
            THEN TO_CHAR(
                    (forecast_dimension.absolute_due_at_ac || ' minutes')::interval,
                    'HH24:MI'
                 )
        END) AS due_TAH,

    MAX(CASE 
            WHEN forecast_dimension.dimension = 'D' 
            THEN TO_CHAR(
                    DATE '1971-12-31' + forecast_dimension.expected_date,
                    'DD MON YYYY'
                 )
        END) AS due_date

FROM forecast_dimension           
WHERE forecast_dimension.event_perfno_i::VARCHAR = COALESCE('@MCC Open MEL per Aircraft.wo_header.event_perfno_i@'::VARCHAR, 'Null')                         
     