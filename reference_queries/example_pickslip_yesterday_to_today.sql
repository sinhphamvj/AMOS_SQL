-- ============================================================
-- VÍ DỤ: LẤY PICKSIPLIP TỪ HÔM QUA ĐẾN HÔM NAY
-- ============================================================
-- Đây là ví dụ mẫu về cách lọc dữ liệu theo ngày trong AMOS
-- Sử dụng cách so sánh DATE_INT trực tiếp (khuyến nghị)
-- ============================================================

SELECT DISTINCT 
    CAST(pickslip_header.pickslipno AS INTEGER),
    pickslip_header.pickslipno,
    pickslip_header.station_from,
    pickslip_header.mech_sign,
    pickslip_header.receiver,
    CASE 
        WHEN pickslip_header.issue_date IS NULL 
        THEN pickslip_header.created_date 
        ELSE pickslip_header.issue_date 
    END AS issue_date,
    pickslip_header.issue_time
FROM pickslip_header
JOIN pickslip_detail ON pickslip_header.pickslipno = pickslip_detail.pickslipno
LEFT JOIN od_detail ON pickslip_detail.oddetailno_i = od_detail.detailno_i
LEFT JOIN od_header ON od_detail.orderno_i = od_header.orderno_i
LEFT JOIN station_store ON od_header.goods_destination = station_store.address_i 
    AND (od_header.order_type = 'T')
WHERE pickslip_header.station_from IN ('SGN', 'HAN', 'DAD', 'CXR', 'HPH', 'VCA', 'PQC', 'VII', 'VTE')
    AND pickslip_header.status IN (0, 1, 2, 4)
    -- So sánh cột INTEGER AMOS (pickslip_header.created_date) với hai giá trị INTEGER AMOS được tính toán:
    -- Từ hôm qua đến hôm nay
    AND pickslip_header.created_date BETWEEN
        ((date_trunc('day', current_timestamp) - interval '1 day')::date - '1971-12-31'::date)
        AND (current_timestamp::date - '1971-12-31'::date);

-- ============================================================
-- CÁC BIẾN THỂ KHÁC
-- ============================================================

-- Lọc từ 7 ngày trước đến hôm nay (thay số 1 thành số 7)
-- AND pickslip_header.created_date BETWEEN
--     ((date_trunc('day', current_timestamp) - interval '7 days')::date - '1971-12-31'::date)
--     AND (current_timestamp::date - '1971-12-31'::date);

-- Lọc từ ngày cụ thể đến hôm nay
-- AND pickslip_header.created_date BETWEEN
--     (TO_DATE('01.01.2024', 'DD.MM.YYYY') - '1971-12-31'::date)
--     AND (current_timestamp::date - '1971-12-31'::date);

-- Lọc trong khoảng ngày cụ thể
-- AND pickslip_header.created_date BETWEEN
--     (TO_DATE('01.01.2024', 'DD.MM.YYYY') - '1971-12-31'::date)
--     AND (TO_DATE('31.01.2024', 'DD.MM.YYYY') - '1971-12-31'::date);

