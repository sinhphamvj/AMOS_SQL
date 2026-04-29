
## get wono_i from 01.Jan.2024 - 31.Dec.2025

- table reference
	- [[wo_header]]
	- [[wo_header_more]]
	- [[wo_classification]]
	- [[workstep_link]]
	- [[wo_text_description]]
	- [[wo_text_action]]

Lấy wo_header làm gốc. Join các table trong table reference. Để lấy toàn bộ thông tin sau để phục vụ cho dự án "AI defect detection"

Đây là query cần phải hoàn thiện
```sql
SELECT
	wo_header.event_perfno_i,
	wo_header.ac_registr,
	wo_header.ata_chapter,
	wo_header.issue_date,
	wo_header.issue_time,
	wo_header.issue_sign,
	wo_header.issue_station,
	wo_header.issue_leg,
	wo_header.issue_tah,
	wo_header.issue_tac,
	wo_header.issue_flt_from,
	wo_header.issue_flt_to,
	wo_hearder_more.wo_class
	
FROM
    wo_header

LEFT JOIN wo_header_more ON wo_header.event_perfno_i = wo_header_more.event_perfno_i

WHERE
    wh.event_perfno_i > 0
    AND wh.workorderno_display IS NOT NULL
    AND wh.event_type NOT IN ('Q', 'T')
    AND (
        (
            wh.issue_date >= 18994
            AND wh.issue_date <= 19724
        )
    )
    AND EXISTS (
        SELECT 1
        FROM aircraft
        WHERE wh.ac_registr = aircraft.ac_registr AND aircraft.ac_registr LIKE 'A%'
    )
    AND wh.type IN ('P', 'M', 'C', 'S')
    AND (
        wh.mel_code IN ('A', 'B', 'C', 'D', 'N', 'L')
        OR wh.hil = 'Y'
    )
    AND wh.state = 'C'
    
```

Để có output ra bảng dữ liệu như sau:

```sql
SELECT
    wh.event_perfno_i,
    wh.ac_registr,
    wh.ata_chapter,
    wh.mel_code,
    wh.issue_date,
    wh.issue_time,
    wh.issue_sign,
    wh.issue_station,
    wh.issue_leg,
    wh.issue_tah,
    wh.issue_tac,
    wh.issue_flt_from,
    wh.issue_flt_to,
    whm.wo_class,
    wtd.header,
    wtd.text,
    wta.text
FROM wo_header wh
LEFT JOIN wo_header_more whm 
    ON wh.event_perfno_i = whm.event_perfno_i
LEFT JOIN workstep_link wsl 
    ON wsl.event_perfno_i = wh.event_perfno_i
LEFT JOIN wo_text_description wtd 
    ON wsl.descno_i = wtd.descno_i
LEFT JOIN wo_text_action wta 
    ON wta.workstep_linkno_i = wsl.workstep_linkno_i
WHERE
    wh.event_perfno_i > 0
    AND wh.workorderno_display IS NOT NULL
    AND wh.event_type NOT IN ('Q', 'T')
    AND wh.issue_date >= 18994
    AND wh.issue_date <= 19724
    AND EXISTS (
        SELECT 1
        FROM aircraft a
        WHERE wh.ac_registr = a.ac_registr
          AND a.ac_registr LIKE 'A%'
    )
    AND wh.type IN ('P', 'M', 'C', 'S')
    AND (
        wh.mel_code IN ('A', 'B', 'C', 'D', 'N', 'L')
        OR wh.hil = 'Y'
    )
    AND wh.state = 'C'
    AND (
        wtd.text IS NULL 
        OR wtd.text <> 'REPETITIVE INSPECTION FOR WO'
    );
```
