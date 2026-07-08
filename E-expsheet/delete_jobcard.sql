-- Xóa các event_template (con) trước để tránh lỗi khóa ngoại (Foreign Key)
DELETE FROM event_template
WHERE wtno_i IN (
    SELECT wtno_i 
    FROM work_template 
    WHERE created_date = 19899 
      AND template_title LIKE '%CAAV-F586-SECTION5-B1%'
);

-- Xóa work_template (cha) sau đó
DELETE FROM work_template
WHERE created_date = 19899 
  AND template_title LIKE '%CAAV-F586-SECTION5-B1%';
