SELECT
   mdr.dailyrecno_i AS "DAILYRECNO",
   mdr.event_perfno_i AS "WO",
   mdr.event_type AS "EVENT_TYPE",
   mdr.ac_registr AS "AC_REG",
   mdr.rep_station AS "STATION",

   TO_CHAR( DATE '1971-12-31' + mdr.occurance_date , 'DD.MON.YYYY') as "ISS_DATE",
   -- Chuyển đổi occurance_time sang định dạng HH24:MI, cộng thêm 7 giờ (420 phút)
   -- và xử lý trường hợp thời gian vượt quá 24 giờ 
  CASE WHEN (mdr.occurance_time + 420) >= 1440 THEN TO_CHAR(
                     TIME '00:00' + (
                        (mdr.occurance_time + 420 - 1440) || ' minutes'
                     ) :: interval,
                     'HH24:MI'
                  ) || '+'
                  ELSE TO_CHAR(
                     TIME '00:00' + ((mdr.occurance_time + 420) || ' minutes') :: interval,
                     'HH24:MI'
                  )
               END AS "ISS_TIME",

   mdr.header AS "DEFECT",
   
   -- Tách ACTUAL DATETIME chỉ lấy ngày và giờ, loại bỏ (UTC)
   TRIM(REGEXP_REPLACE(
       SUBSTRING(
           regexp_replace(mdr.description, '<[^>]*>|&#34;|&#160;', '', 'g')
           FROM 'ORIGINAL STD[:]?\s*([^D]+)(?=DEFECT)'
       ),
       '\s*\(UTC\).*$', ''
   )) AS "ORIGINAL_STD",
   
   -- Tách DEFECT lấy nội dung giữa DEFECT và REASON REQUEST (sửa regex)
   TRIM(SUBSTRING(
       regexp_replace(mdr.description, '<[^>]*>|&#34;|&#160;', '', 'g')
       FROM 'DEFECT[:]?\s*(.*?)(?=REASON REQUEST)'
   )) AS "DEFECT_DETAIL",
   
   -- Tách REASON REQUEST
   TRIM(SUBSTRING(
       regexp_replace(mdr.description, '<[^>]*>|&#34;|&#160;', '', 'g')
       FROM 'REASON REQUEST[:]?\s*(.+?)$'
   )) AS "REASON_REQUEST",

   -- Tách EST_SERVICE_DATE từ NOTE_HEADER
   TRIM(SUBSTRING(
       mnd.header
       FROM 'SET NEW ADVISETIME TO:\s*(\d{1,2}\.\w{3}\.\d{4})'
   )) AS "EST_SERVICE_DATE",
   
   -- Tách EST_SERVICE_TIME từ NOTE_HEADER
   TO_CHAR(
       (TRIM(SUBSTRING(mnd.header FROM 'SET NEW ADVISETIME TO:\s*(\d{1,2}\.\w{3}\.\d{4})')) || ' ' ||
        TRIM(SUBSTRING(mnd.header FROM 'SET NEW ADVISETIME TO:\s*\d{1,2}\.\w{3}\.\d{4}\s+(\d{2}:\d{2})')))::TIMESTAMP AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Saigon',
       'HH24:MI'
   ) AS "EST_SERVICE_TIME",

    -- Loại bỏ HTML tags và ký tự đặc biệt trong NOTE_TEXT
    TRIM(REGEXP_REPLACE(
        mnd.text, 
        '<[^>]*>|&[a-zA-Z0-9#]+;|[\r\n\t]+|\s{2,}', 
        ' ', 
        'g'
    )) AS "NOTE_TEXT", -- Nếu sử dụng bảng html thì khoogn  cần loại bỏ ký tự đặc biệt
mdr.flightno AS "FLIGHT_NO"


FROM moc_daily_records mdr
JOIN (
    SELECT
        dailyrecno_i,
        MAX(moc_noteno_i) AS max_moc_noteno_i
    FROM moc_daily_note
    WHERE header LIKE '%SET NEW ADVISETIME TO:%'
    GROUP BY dailyrecno_i
) AS latest_note ON mdr.dailyrecno_i = latest_note.dailyrecno_i
JOIN moc_daily_note mnd ON latest_note.dailyrecno_i = mnd.dailyrecno_i AND latest_note.max_moc_noteno_i = mnd.moc_noteno_i
   
WHERE 
mdr.occurance_date = @VAR.DATE@
AND mdr.occurance_time >= 900
AND mdr.event_group = 'TL'


ORDER BY mdr.event_type, DATE '1971-12-31' + mdr.occurance_date
  , mdr.occurance_time
