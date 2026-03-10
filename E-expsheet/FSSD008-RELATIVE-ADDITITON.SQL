SELECT 
    -- 5. ANH/ CHỊ/ EM RUỘT THỨ 3 (xuất hiện lần đầu tiên trong file độc lập này)
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Sibling’s full name):', 2), '<', 1)) AS ace3_ho_ten,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Year of birth):', 2), '<', 1)) AS ace3_nam_sinh,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Occupation):', 2), '<', 1)) AS ace3_nghe_nghiep,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Company’s name):', 2), '<', 1)) AS ace3_co_quan,

    -- 6. ANH/ CHỊ/ EM RUỘT THỨ 4 (xuất hiện lần thứ 2 trong file độc lập này)
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Sibling’s full name):', 3), '<', 1)) AS ace4_ho_ten,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Year of birth):', 3), '<', 1)) AS ace4_nam_sinh,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Occupation):', 3), '<', 1)) AS ace4_nghe_nghiep,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Company’s name):', 3), '<', 1)) AS ace4_co_quan,

    -- 7. ANH/ CHỊ/ EM RUỘT THỨ 5 (xuất hiện lần thứ 3 trong file độc lập này)
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Sibling’s full name):', 4), '<', 1)) AS ace5_ho_ten,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Year of birth):', 4), '<', 1)) AS ace5_nam_sinh,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Occupation):', 4), '<', 1)) AS ace5_nghe_nghiep,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Company’s name):', 4), '<', 1)) AS ace5_co_quan

FROM db_link
WHERE
    db_link.source_pk = 'VJC4679'
    AND db_link.source_type = 'SG'
    AND db_link.description = 'PERSONAL_INFO_RELATIVES_ADDITITION';
