SELECT
    TO_CHAR(TRUNC(SUM(CASE WHEN rotables.partno = 'GA140V13-VJGS' THEN time_captured.duration ELSE 0 END) / 60), 'FM00') || ':' || 
    TO_CHAR(MOD(SUM(CASE WHEN rotables.partno = 'GA140V13-VJGS' THEN time_captured.duration ELSE 0 END), 60), 'FM00') AS VJGS_GPU,
    
    TO_CHAR(TRUNC(SUM(CASE WHEN rotables.partno IN ('GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END) / 60), 'FM00') || ':' || 
    TO_CHAR(MOD(SUM(CASE WHEN rotables.partno IN ('GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END), 60), 'FM00') AS VJ_GPU,
    
    TO_CHAR(TRUNC(SUM(CASE WHEN rotables.partno IN ('GA140V13-VJGS', 'GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END) / 60), 'FM00') || ':' || 
    TO_CHAR(MOD(SUM(CASE WHEN rotables.partno IN ('GA140V13-VJGS', 'GA100V12D2000', 'GA140V13') THEN time_captured.duration ELSE 0 END), 60), 'FM00') AS TOTAL
FROM
    wp_header
    LEFT JOIN time_captured_additional ON time_captured_additional.wpno_i = wp_header.wpno_i
    JOIN time_captured ON time_captured.bookingno_i = time_captured_additional.bookingno_i
                      AND time_captured.mime_type = 'JCA'
    LEFT JOIN rotables ON time_captured.psn = rotables.psn
WHERE
    wpno IN ('A522-OWP-220426-REV00','A535-OWP-220426-REV00','A524-OWP-220426-REV00','A630-OWP-220426-REV00')
    AND wp_header.station = 'SGN'
