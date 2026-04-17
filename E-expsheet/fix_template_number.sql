-- ============================================================
-- fix_template_number.sql
-- Mục đích : Sửa cột template_number trong bảng work_template
--            → phần nguyên được pad thành đúng 3 chữ số (zero-fill)
--            → phần thập phân (nếu có) giữ nguyên
-- Ví dụ    : 1    → 001
--            95   → 095
--            3.1  → 003.1
--            95.1 → 095.1
--            100  → 100   (đã đủ 3 chữ số, không đổi)
-- ============================================================

UPDATE work_template
SET template_number =
    CASE
        -- Có phần thập phân: pad phần nguyên, giữ '.<decimal>'
        WHEN template_number LIKE '%.%'
            THEN LPAD(SPLIT_PART(template_number, '.', 1), 3, '0')
                 || '.'
                 || SPLIT_PART(template_number, '.', 2)
        -- Không có dấu chấm: pad toàn bộ
        ELSE LPAD(template_number, 3, '0')
    END
WHERE
    template_title LIKE 'CAAV-F586-SECTION5-B1-%'
    AND LENGTH(SPLIT_PART(template_number, '.', 1)) < 3
    AND template_number ~ '^[0-9]';
