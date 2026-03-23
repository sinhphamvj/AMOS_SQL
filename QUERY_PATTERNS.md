# 🔄 Query Patterns - Các Pattern Query Thường Dùng

Các pattern query thường được sử dụng trong hệ thống AMOS.

## 📅 Xử lý ngày tháng AMOS

### Pattern 1: Chuyển đổi DATE_INT sang DATE (hiển thị)
```sql
-- Hiển thị ngày từ DATE_INT
SELECT 
    (DATE '1971-12-31' + wo_header.issue_date)::DATE AS issue_date
FROM wo_header;

-- Format với TO_CHAR
SELECT 
    TO_CHAR(DATE '1971-12-31' + wo_header.issue_date, 'DD.MON.YYYY') AS issue_date
FROM wo_header;

-- Lưu ý: Không sử dụng hàm amos_to_date() trong query vì AMOS không hỗ trợ
```

### Pattern 2: Lọc theo khoảng thời gian (AMOS DATE_INT)
```sql
-- Lọc từ hôm qua đến hôm nay (khuyến nghị - cách AMOS sử dụng)
SELECT * FROM pickslip_header
WHERE pickslip_header.created_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval '1 day')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date);

-- Lọc từ N ngày trước đến hôm nay (thay số 1 bằng số ngày muốn tính)
SELECT * FROM wo_header
WHERE wo_header.issue_date BETWEEN
    ((date_trunc('day', current_timestamp) - interval '7 days')::date - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date);

-- Lọc từ ngày cụ thể đến hôm nay
SELECT * FROM wo_header
WHERE wo_header.issue_date BETWEEN
    (TO_DATE('01.01.2024', 'DD.MM.YYYY') - '1971-12-31'::date)
    AND (current_timestamp::date - '1971-12-31'::date);

-- Lọc trong khoảng ngày cụ thể
SELECT * FROM wo_header
WHERE wo_header.issue_date BETWEEN
    (TO_DATE('01.01.2024', 'DD.MM.YYYY') - '1971-12-31'::date)
    AND (TO_DATE('31.01.2024', 'DD.MM.YYYY') - '1971-12-31'::date);
```

### Pattern 2b: Lọc theo ngày (cách cũ - không khuyến nghị)
```sql
-- Cách này chuyển đổi DATE_INT sang DATE rồi so sánh (chậm hơn)
SELECT * FROM wo_header
WHERE (DATE '1971-12-31' + issue_date)::DATE >= DATE_TRUNC('month', CURRENT_DATE)
    AND (DATE '1971-12-31' + issue_date)::DATE < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month';
```

## 🔍 Work Order Patterns

### Pattern 3: Lấy WO đang mở
```sql
SELECT * FROM wo_header
WHERE state = 'O'
    AND type IN ('M', 'P', 'C', 'S')
    AND workorderno_display IS NOT NULL;
```

### Pattern 4: Lấy WO đã đóng
```sql
SELECT * FROM wo_header
WHERE state = 'C'
    AND type IN ('M', 'P', 'C', 'S')
    AND workorderno_display IS NOT NULL;
```

### Pattern 5: Lấy WO theo máy bay
```sql
SELECT * FROM wo_header
WHERE ac_registr = 'VN-A123'  -- Thay bằng mã máy bay
    AND state = 'O';
```

### Pattern 6: Lấy WO có MEL
```sql
SELECT 
    wo.*,
    wo_more.mel_chapter
FROM wo_header wo
LEFT JOIN wo_header_more wo_more ON wo.event_perfno_i = wo_more.event_perfno_i
WHERE wo.mel_code IN ('A', 'B', 'C', 'D', 'L')
    AND wo.state = 'O';
```

## 🎫 Jobcard Patterns

### Pattern 7: Lấy Jobcard
```sql
SELECT * FROM wo_header
WHERE event_type = 'JC'
    AND type = 'PD'
    AND event_perfno_i > 0
    AND workorderno_display IS NULL;
```

### Pattern 8: Parse WO number từ tên Jobcard
```sql
SELECT 
    wt.template_number AS jobcard_name,
    CAST(NULLIF(SPLIT_PART(wt.template_number, '-', 3), '') AS INTEGER) AS wo_event_perfno_i
FROM work_template wt
WHERE wt.template_type = 'J'
    AND wt.status = 0
    AND wt.template_number ~ '^JC-[^-]+-[0-9]+$';
```

### Pattern 9: Jobcard với WO đã đóng
**Reference Query**: Xem `reference_queries/get_all_jobcards.sql` ⭐ (Query mẫu chính xác)

```sql
-- Pattern chính từ reference query
SELECT 
    jc.event_perfno_i AS "JOBCARD_ID",
    t.template_number AS "JOBCARD_NAME",
    wo.workorderno_display AS "WO_NUMBER",
    wo.closing_date AS "WO_CLOSING_DATE"
FROM (
    SELECT
        wt.wtno_i,
        wt.template_number,
        CAST(NULLIF(SPLIT_PART(wt.template_number, '-', 3), '') AS INTEGER) AS extracted_wono
    FROM work_template wt
    WHERE wt.status = 0
        AND wt.template_type = 'J'
        AND wt.template_number ~ '^JC-[^-]+-[0-9]+$'
) AS t
INNER JOIN wo_header wo ON t.extracted_wono = wo.event_perfno_i
    AND wo.state = 'C'
    -- Lọc theo thời gian (ví dụ: 30 ngày)
    AND wo.closing_date BETWEEN
        ((date_trunc('day', current_timestamp) - interval '30 days')::date - '1971-12-31'::date)
        AND (current_timestamp::date - '1971-12-31'::date)
LEFT JOIN wo_header jc ON jc.template_revisionno_i = t.wtno_i
    AND jc.event_type = 'JC'
    AND jc.type = 'PD'
    AND jc.workorderno_display IS NULL;
```

**Xem chi tiết**: `reference_queries/get_all_jobcards.sql` - Query đầy đủ với tất cả cột và comment

## 🔗 Join Patterns

### Pattern 10: Join WO với thông tin bổ sung
```sql
SELECT 
    wo.*,
    wo_more.wo_class,
    wo_more.mel_chapter
FROM wo_header wo
LEFT JOIN wo_header_more wo_more ON wo.event_perfno_i = wo_more.event_perfno_i;
```

### Pattern 11: Join WO với description
```sql
SELECT 
    wo.*,
    desc.text AS description
FROM wo_header wo
LEFT JOIN workstep_link wl ON wo.event_perfno_i = wl.event_perfno_i
    AND wl.sequenceno = (
        SELECT MAX(sequenceno) 
        FROM workstep_link wl2 
        WHERE wl2.event_perfno_i = wo.event_perfno_i
    )
LEFT JOIN wo_text_description desc ON wl.descno_i = desc.descno_i;
```

### Pattern 12: Join qua db_link
```sql
-- Tìm WO liên kết với Jobcard
SELECT 
    jc.event_perfno_i AS jobcard_id,
    wo.event_perfno_i AS wo_id,
    wo.workorderno_display AS wo_number
FROM wo_header jc
JOIN db_link ON jc.event_perfno_i::VARCHAR = db_link.source_pk
    AND db_link.source_type = 'WO'
JOIN wo_header wo ON db_link.destination_key = wo.event_perfno_i::VARCHAR
WHERE jc.event_type = 'JC';
```

## 📦 Work Package Patterns

### Pattern 13: Lấy WP theo máy bay
```sql
SELECT * FROM wp_header
WHERE ac_registr = 'VN-A123'
    AND state = 'O';
```

### Pattern 14: WP với events
```sql
SELECT 
    wp.*,
    wp_h.event_type,
    wp_h.event_perfno_i
FROM wp_header wp
LEFT JOIN wp_history wp_h ON wp.wpno_i = wp_h.wpno_i;
```

## 👥 Resource Patterns

### Pattern 15: Resource theo station
```sql
SELECT 
    s.*,
    sua.entry_type,
    sp_shift.location AS station
FROM sign s
JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
LEFT JOIN sp_shift ON sua.shift_id = sp_shift.shift_id
WHERE s.department = 'VJC AMO'
    AND s.status = 0
    AND sp_shift.location = 'SGN';  -- Thay bằng station
```

### Pattern 16: Resource online
```sql
SELECT 
    s.user_sign,
    s.skill_shop,
    sua.entry_type,
    sp_shift.location
FROM sign s
JOIN sp_user_availability sua ON s.user_sign = sua.user_sign
LEFT JOIN sp_day_entry_type ON sua.entry_type = sp_day_entry_type.type_id
LEFT JOIN sp_shift ON sua.shift_id = sp_shift.shift_id
WHERE s.department = 'VJC AMO'
    AND s.status = 0
    AND sp_day_entry_type.maintenance_context = 'Y'
    AND (DATE '1971-12-31' + sua.start_date)::DATE = CURRENT_DATE;
```

## 🔩 Part Patterns

### Pattern 17: Part on/off trong WO
```sql
SELECT 
    wo.ac_registr,
    part.event_perfno_i AS wo_id,
    part.partno AS part_on,
    part.serialno AS serial_on,
    part.partno_off AS part_off,
    part.serialno_off AS serial_off,
    (DATE '1971-12-31' + part.created_date)::DATE AS created_date
FROM wo_part_on_off part
JOIN wo_header wo ON part.event_perfno_i = wo.event_perfno_i
WHERE part.status = 0
    AND (DATE '1971-12-31' + part.created_date)::DATE >= CURRENT_DATE - INTERVAL '30 days';
```

## 📊 Aggregation Patterns

### Pattern 18: Đếm WO theo trạng thái
```sql
SELECT 
    state,
    COUNT(*) AS count
FROM wo_header
WHERE type IN ('M', 'P', 'C', 'S')
GROUP BY state;
```

### Pattern 19: Đếm WO theo máy bay
```sql
SELECT 
    ac_registr,
    state,
    COUNT(*) AS count
FROM wo_header
WHERE type IN ('M', 'P', 'C', 'S')
GROUP BY ac_registr, state
ORDER BY ac_registr, state;
```

### Pattern 20: Thống kê WP theo station
```sql
SELECT 
    wp.ac_registr,
    COUNT(DISTINCT wp.wpno_i) AS wp_count,
    COUNT(DISTINCT wp_h.event_perfno_i) AS event_count
FROM wp_header wp
LEFT JOIN wp_history wp_h ON wp.wpno_i = wp_h.wpno_i
WHERE wp.state = 'O'
GROUP BY wp.ac_registr;
```

## 🔍 Filter Patterns

### Pattern 21: Lọc với CASE WHEN
```sql
SELECT 
    event_perfno_i,
    ac_registr,
    CASE 
        WHEN mel_code = 'L' THEN 'CDL'
        WHEN mel_code IN ('A', 'B', 'C', 'D') THEN 'MEL'
        ELSE ''
    END AS mel_type
FROM wo_header
WHERE mel_code IS NOT NULL;
```

### Pattern 22: Lọc với ROW_NUMBER
```sql
SELECT 
    ROW_NUMBER() OVER (
        ORDER BY 
            CASE 
                WHEN homebase = 'SGN' THEN 1
                WHEN homebase = 'HAN' THEN 2
                ELSE 3
            END,
            created_date
    ) AS seq,
    *
FROM your_table;
```

## 📝 Lưu ý quan trọng

### Xử lý ngày tháng AMOS
- **So sánh DATE_INT**: Luôn chuyển ngày hiện tại/tương lai thành INTEGER rồi so sánh trực tiếp với cột DATE_INT
- **Công thức**: `(current_timestamp::date - '1971-12-31'::date)` để lấy số ngày từ mốc
- **Hiển thị DATE_INT**: Dùng `(DATE '1971-12-31' + date_column)::DATE` để hiển thị
- **Không dùng hàm**: Không sử dụng hàm `amos_to_date()` trong query

### Query optimization
- Luôn kiểm tra `status = 0` cho các bảng có cột status (active records)
- Sử dụng `LEFT JOIN` khi có thể có NULL
- Sử dụng `INNER JOIN` khi cần đảm bảo có dữ liệu
- Format ngày tháng theo yêu cầu: `TO_CHAR(date, 'DD.MON.YYYY')`
- Sử dụng regex pattern để validate format: `~ '^pattern$'`

## 🔗 Xem thêm

- [Table Reference](./TABLE_REFERENCE.md) - Tham chiếu bảng
- [Index](./INDEX.md) - Danh mục query
- [Schema SQL](./vietjet_amos_schema.sql) - Schema đầy đủ database
- [README](./README.md) - Tổng quan

