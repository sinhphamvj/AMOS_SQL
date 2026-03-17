SELECT 
    '/' || LTRIM(latest_history.file_path, '/') AS file_path
FROM (
    SELECT DISTINCT ON (LTRIM(file_path, '/'))
        file_path,
        action,
        web_drive_history_no_i
    FROM web_drive_history
    WHERE file_path LIKE '%AMO/HR/PROFILES/VJC4679-PHAM VAN SINH/CAAV/%'
    ORDER BY LTRIM(file_path, '/'), web_drive_history_no_i DESC
) latest_history
WHERE latest_history.action NOT LIKE 'Manually Deleted%'
  AND latest_history.action NOT LIKE 'Renamed to%'