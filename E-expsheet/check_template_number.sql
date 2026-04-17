-- ============================================================
-- check_template_number.sql
-- Mục đích : Kiểm tra TRƯỚC khi chạy fix_template_number.sql
--            Không thay đổi dữ liệu thật
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- BƯỚC 1: Xem tổng số bản ghi SẼ bị UPDATE
-- ────────────────────────────────────────────────────────────
SELECT
    COUNT(*) AS "Tổng số dòng sẽ được UPDATE"
FROM work_template
WHERE
    template_title LIKE 'CAAV-F586-SECTION5-B1-%'
    AND LENGTH(SPLIT_PART(template_number, '.', 1)) < 3
    AND template_number ~ '^[0-9]';


-- ────────────────────────────────────────────────────────────
-- BƯỚC 2: Xem chi tiết từng dòng - giá trị CŨ vs MỚI
-- ────────────────────────────────────────────────────────────
SELECT
    wtno_i,
    template_title,
    template_number                                         AS "Giá trị CŨ",
    CASE
        WHEN template_number LIKE '%.%'
            THEN LPAD(SPLIT_PART(template_number, '.', 1), 3, '0')
                 || '.'
                 || SPLIT_PART(template_number, '.', 2)
        ELSE LPAD(template_number, 3, '0')
    END                                                     AS "Giá trị MỚI",
    CASE
        WHEN template_number LIKE '%.%'
            THEN LPAD(SPLIT_PART(template_number, '.', 1), 3, '0')
                 || '.'
                 || SPLIT_PART(template_number, '.', 2)
        ELSE LPAD(template_number, 3, '0')
    END = template_number                                   AS "Không thay đổi?"
FROM work_template
WHERE
    template_title LIKE 'CAAV-F586-SECTION5-B1-%'
    AND LENGTH(SPLIT_PART(template_number, '.', 1)) < 3
    AND template_number ~ '^[0-9]'
ORDER BY
    CAST(SPLIT_PART(template_number, '.', 1) AS INTEGER),
    template_number;


-- ────────────────────────────────────────────────────────────
-- BƯỚC 3: Chạy thử trong transaction rồi ROLLBACK (an toàn nhất)
--         Kết quả trả về số dòng bị ảnh hưởng mà không lưu vào DB
-- ────────────────────────────────────────────────────────────
BEGIN;

UPDATE work_template
SET template_number =
    CASE
        WHEN template_number LIKE '%.%'
            THEN LPAD(SPLIT_PART(template_number, '.', 1), 3, '0')
                 || '.'
                 || SPLIT_PART(template_number, '.', 2)
        ELSE LPAD(template_number, 3, '0')
    END
WHERE
    template_title LIKE 'CAAV-F586-SECTION5-B1-%'
    AND LENGTH(SPLIT_PART(template_number, '.', 1)) < 3
    AND template_number ~ '^[0-9]';

-- Xem lại dữ liệu SAU khi UPDATE (trong transaction, chưa commit)
SELECT
    wtno_i,
    template_title,
    template_number AS "Giá trị SAU UPDATE (chưa commit)"
FROM work_template
WHERE
    template_title LIKE 'CAAV-F586-SECTION5-B1-%'
ORDER BY
    CAST(SPLIT_PART(template_number, '.', 1) AS INTEGER),
    template_number;

-- Huỷ toàn bộ thay đổi, dữ liệu thật KHÔNG bị ảnh hưởng
ROLLBACK;
