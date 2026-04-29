# Reference

[[time_captured]]
- bookingno_i
- psn
[[time_captured_additional]]
- bookingno_i
- wpno_i
[[rotables]]
- psn
[[wp_header]]
- 

## variable 
- @VAR.CHECK_DATE@ 
- @VAR. AVG_APU_FUEL@
- @VAR.APU_FUEL_PRICE@

## gpu_of_VJAMO

| no  | partNumber    | serialNumber | location                  |
| --- | ------------- | ------------ | ------------------------- |
| 1   | GA100V12D2000 | 13187        | HAN / MAIN / GSE01        |
| 2   | GA100V12D2000 | 13188        | SGN / MAIN / GSE LOCATION |
| 3   | GA100V12D2000 | 14363        | CXR / CXR-LINE / TOOLS    |
| 4   | GA100V12D2000 | 14364        | HAN / MAIN / GSE01        |
| 5   | GA100V12D2000 | 14365        | SGN / MAIN / GSE LOCATION |
| 6   | GA100V12D2000 | 15674        | DAD / MAIN / GSE HWC      |
| 7   | GA100V12D2000 | 15675        | SGN / MAIN / GSE LOCATION |
| 8   | GA100V12D2000 | 15676        | SGN / MAIN / GSE LOCATION |

## gpu_of_partner

| no  | partNumber    | serialNumber |
| --- | ------------- | ------------ |
| 01  | GA140V13-VJGS | GPU-SGN      |
| 02  | GA140V13-VJGS | GPU-HAN      |
| 03  | GPU-ACV       | GPU-HPH      |
| 04  | GPU-ACV       | GPU-VII      |
| 05  | GPU-ACV       | GPU-VCA      |
| 06  | GPU-ACV       | GPU-PXU      |
| 07  | GPU-SAC       | GPU-PQC      |
| 08  | GPU-SAGS      | GPU-DAD      |
| 09  | GPU-SAGS      | GPU-CXR      |

```sql

SELECT 
       time_captured.psn,
       
	   wp_header.station,
	   time_captured_additional.wpno_i,
	   time_captured_additional.ac_registr,
	   
	   rotables.partno,
	   rotables.serialno,
       time_captured.duration,
       time_captured.start_date,
       time_captured.start_time,
       time_captured.end_date,
       time_captured.end_time,


	   time_captured_additional.remarks,
	   

	   


FROM time_captured

	JOIN time_captured_additional  ON time_captured_additional.bookingno_i = time_captured.bookingno_i
	JOIN rotables ON rotables.psn =  time_captured.psn
	JOIN wp_header ON wp_header.wpno_i = time_captured_additional.wpno_i

WHERE time_captured.start_date >= @VAR.CHECK_DATE@
      AND time_captured.start_date <= @VAR.CHECK_DATE@
      AND time_captured.psn IS NOT NULL  
      
```

## table Output

- @VAR.CHECK_DATE@  = 19840 (start-end) `time_captured.start_date >= 19840 AND time_captured.start_date <= 19840`

| psn    | ac_registr | partno        | serialno | duration | start_date | station | start_time | end_date | end_time | remarks   |
| ------ | ---------- | ------------- | -------- | -------- | ---------- | ------- | ---------- | -------- | -------- | --------- |
| 198177 | A547       | GA100V12D2000 | 13187    | 150      | 19840      | HAN     | 870        | 19840    | 1020     |           |
| 198177 | A522       | GA100V12D2000 | 13187    | 0        | 19840      | HAN     | 954        | 19840    | 954      |           |
| 198179 | A642       | GA100V12D2000 | 14365    | 160      | 19840      | SGN     | 900        | 19840    | 1060     |           |
| 198179 | A697       | GA100V12D2000 | 14365    | 80       | 19840      | SGN     | 1119       | 19840    | 1199     |           |
| 198179 | A607       | GA100V12D2000 | 14365    | 85       | 19840      | SGN     | 700        | 19840    | 785      |           |
| 198180 | A648       | GA100V12D2000 | 14363    | 111      | 19840      | CXR     | 1022       | 19840    | 1133     |           |
| 198180 | A537       | GA100V12D2000 | 14363    | 103      | 19840      | CXR     | 957        | 19840    | 1060     |           |
| 198180 | A641       | GA100V12D2000 | 14363    | 120      | 19840      | CXR     | 842        | 19840    | 962      |           |
| 198180 | A526       | GA100V12D2000 | 14363    | 120      | 19840      | CXR     | 880        | 19840    | 1000     |           |
| 198180 | A640       | GA100V12D2000 | 14363    | 0        | 19840      | CXR     | 600        | 19840    | 600      |           |
| 198180 | A648       | GA100V12D2000 | 14363    | 0        | 19840      | CXR     | 345        | 19840    | 345      |           |
| 733977 | A553       | GA140V13-VJGS | GPU-SGN  | 105      | 19840      | SGN     | 980        | 19840    | 1085     |           |
| 733979 | A668       | GA140V13-VJGS | GPU-HAN  | 120      | 19840      | HAN     | 940        | 19840    | 1060     |           |
| 736215 | A545       | GPU-ACV       | GPU-HPH  | 50       | 19840      | HPH     | 170        | 19840    | 220      |           |
| 737645 | A698       | GPU-SAGS      | GPU-DAD  | 60       | 19840      | DAD     | 1294       | 19840    | 1354     |           |
| 737645 | A676       | GPU-SAGS      | GPU-DAD  | 30       | 19840      | DAD     | 1050       | 19840    | 1080     | No SN GPU |
| 737645 | A683       | GPU-SAGS      | GPU-DAD  | 110      | 19840      | DAD     | 205        | 19840    | 315      |           |

## Chế biến món ăn

### Daily Report/Dashboard

@VAR.CHECK_DATE@  = 19840 (start-end) `time_captured.start_date >= 19840 AND time_captured.start_date <= 19840`

| **start_date** | integer | DATE_INT | The date the booking step was started.                                         |
| -------------- | ------- | -------- | ------------------------------------------------------------------------------ |
| **start_time** | integer | TIME     | The time the booking step was started.                                         |
| **end_date**   | integer | DATE_INT | The date the bookign step was stopped.                                         |
| **end_time**   | integer | TIME     | The time the booking step was stopped.                                         |
| **duration**   | integer | TIME_AMO | The duration minutes. **This is always the difference between end and start.** |

Hiển thị ngày giờ

```sql
TO_CHAR(
          DATE '1971-12-31' + time_captured.start_date,
          'DD.Mon.YYYY'
       ) AS START_DATE,
       
 TO_CHAR(
          TRUNC(time_captured.start_time / 60),
          'FM00'
       ) || ':' ||     TO_CHAR(
          MOD(
             time_captured.start_time,
             60
          ),
          'FM00'
       ) AS START_TIME,
```

Yêu cầu cần viết query:
 
- **totalDailyGpuTime** = sum(time_captured.duration) - Tính xong rồi chuyển định đạng
	- format display: hh:mm
	- Ví du: totalDailyGpuTime = 54:00
- **totalDailyVJGpuTime** = sum(time_captured.duration) + where => partno belong {# gpu_of_VJAMO}
	-  format display: hh:mm
- **totalDailyVJGpuTime** = sum(time_captured.duration) with WHERE partno belong VJ AMO.
- **totalDailyPartnerGpuTime** = sum(duration) + where => partno  `NOT`  belong {# gpu_of_VJAMO}
- totalFuelSaving = totalDailyGpuTime x @VAR. AVG_APU_FUEL@ - Đơn vị là `KG`
- totalMoneySaving = totalDailyGpuTime x @VAR. AVG_APU_FUEL@ x @VAR.APU_FUEL_PRICE@ - Đơn vị là 'VND'

Note: do chưa có price of GPU nên sử dụng tạm công thức này để tính
- Cần @VAR. AVG_GPU_FUEL@  và @VAR. GPU_FUEL_PRICE@

```sql
SELECT
    /* 1. TOTAL DAILY GPU TIME (hh:mm) */
    TO_CHAR(TRUNC(SUM(time_captured.duration) / 60), 'FM00') || ':' || 
    TO_CHAR(MOD(SUM(time_captured.duration), 60), 'FM00') 
    AS "totalDailyGpuTime",

    /* 2. TOTAL DAILY VJ GPU TIME (hh:mm)
       Lọc theo PN: GA100V12D2000 */
    TO_CHAR(TRUNC(SUM(CASE 
        WHEN rotables.partno = 'GA100V12D2000' 
        THEN time_captured.duration ELSE 0 END) / 60), 'FM00') || ':' || 
    TO_CHAR(MOD(SUM(CASE 
        WHEN rotables.partno = 'GA100V12D2000' 
        THEN time_captured.duration ELSE 0 END), 60), 'FM00') 
    AS "totalDailyVJGpuTime",

    /* 3. TOTAL DAILY PARTNER GPU TIME (hh:mm)
       Lọc các PN KHÔNG PHẢI GA100V12D2000 */
    TO_CHAR(TRUNC(SUM(CASE 
        WHEN rotables.partno != 'GA100V12D2000' 
        THEN time_captured.duration ELSE 0 END) / 60), 'FM00') || ':' || 
    TO_CHAR(MOD(SUM(CASE 
        WHEN rotables.partno != 'GA100V12D2000' 
        THEN time_captured.duration ELSE 0 END), 60), 'FM00') 
    AS "totalDailyPartnerGpuTime",

    /* 4. TOTAL FUEL SAVING (KG)
       Công thức: (Tổng phút / 60) * @VAR.AVG_APU_FUEL@ */
    ROUND(
        (SUM(time_captured.duration) / 60.0) * @VAR.AVG_APU_FUEL@
    , 2) AS "totalFuelSaving",

    /* 5. TOTAL MONEY SAVING (VND)
       Công thức: Fuel Saving * @VAR.APU_FUEL_PRICE@
       Định dạng: 130.230.200 VND */
    REPLACE(
        TO_CHAR(
            ROUND((SUM(time_captured.duration) / 60.0) * @VAR.AVG_APU_FUEL@ * @VAR.APU_FUEL_PRICE@, 0),
            'FM999,999,999,999,990'
        ),
        ',', '.'
    ) || ' VND' AS "totalMoneySaving"

FROM 
    time_captured
    JOIN time_captured_additional ON time_captured_additional.bookingno_i = time_captured.bookingno_i
    JOIN rotables ON rotables.psn = time_captured.psn
    JOIN wp_header ON wp_header.wpno_i = time_captured_additional.wpno_i

WHERE 
    /* Fix lỗi Trailing Junk bằng cách bọc nháy đơn và convert */
    time_captured.start_date = TO_DATE('@VAR.CHECK_DATE@', 'DD.Mon.YYYY') - DATE '1971-12-31'
    AND time_captured.psn IS NOT NULL
    AND time_captured.mime_type = 'JCA' /*Có những trường hợp anh em book tool vào WO => Chỉ lấy các JCA định danh*/
```


- Thêm điều kiện where = wp_header.station = ''
	- DAILY_GPU_STATS_SGN
		- SGN
	- HAN
	- DAD
	- CXR
	- HPH
	- VCA
	- PQC
#### Đếm số lượng sử dụng GPU của từng station `SGN`, `HAN`,`DAD`,`CXR`,`HPH`,`VII`,`VCA`,`PQC` trong 1 query
- totalGpuUsageCount = 
- totalVjGpuUsageCount =
- totalParterUsageCount =


| STATION | TOTAL_GPU_USAGE | TOTAL_VJGPU_USAGE | TOTAL_PARTER_GPU_USAGE |
| ------- | --------------- | ----------------- | ---------------------- |
| SGN     | 7               | 3                 | 4                      |
| HAN     |                 |                   |                        |
| DAD     |                 |                   |                        |
| CXR     |                 |                   |                        |


```sql
SELECT
    /* 1. Đếm số lượt sử dụng GPU của VJC tại SGN */
    COUNT(CASE 
        WHEN rotables.partno IN ('GA100V12D2000', 'GA140V13') 
        THEN 1 END) AS VJ_GPU_COUNT_SGN,

    /* 2. Đếm số lượt sử dụng GPU của ĐỐI TÁC (Partner) tại SGN */
    COUNT(CASE 
        WHEN rotables.partno NOT IN ('GA100V12D2000', 'GA140V13') 
        THEN 1 END) AS PARTNER_GPU_COUNT_SGN,

    /* 3. Tổng cộng số lượt sử dụng GPU tại SGN */
    COUNT(rotables.partno) AS TOTAL_GPU_USAGE_SGN

FROM
    wp_header
    LEFT JOIN time_captured_additional ON time_captured_additional.wpno_i = wp_header.wpno_i
    JOIN time_captured ON time_captured.bookingno_i = time_captured_additional.bookingno_i
                      AND time_captured.mime_type = 'JCA'
    LEFT JOIN rotables ON time_captured.psn = rotables.psn
WHERE
    /* Lọc theo ngày check */
    (   wpno LIKE '%OWP-'  || TO_CHAR(TO_DATE('@VAR.CHECK_DATE@', 'DD.Mon.YYYY'), 'DDMMYY') || '%'
     OR wpno LIKE '%TXWP-' || TO_CHAR(TO_DATE('@VAR.CHECK_DATE@', 'DD.Mon.YYYY'), 'DDMMYY') || '%')
    /* Lọc riêng cho trạm SGN */
    AND wp_header.station = 'SGN'
    AND rotables.partno IS NOT NULL
```
### Weekly Report/Dashboard
@VAR.CHECK_DATE@  = weekly (start-end) `time_captured.start_date >= 19838 AND time_captured.start_date <= 19845`

