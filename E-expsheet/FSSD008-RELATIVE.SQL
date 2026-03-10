SELECT 
    -- 1. CHA
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Father’s full name):', 2), '<', 1)) AS cha_ho_ten,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Year of birth):', 2), '<', 1)) AS cha_nam_sinh,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Occupation):', 2), '<', 1)) AS cha_nghe_nghiep,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Company’s name):', 2), '<', 1)) AS cha_co_quan,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Current address):', 2), '<', 1)) AS cha_cho_o,

    -- 2. MẸ
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Mother’s full name):', 2), '<', 1)) AS me_ho_ten,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Year of birth):', 3), '<', 1)) AS me_nam_sinh,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Occupation):', 3), '<', 1)) AS me_nghe_nghiep,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Company’s name):', 3), '<', 1)) AS me_co_quan,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Current address):', 3), '<', 1)) AS me_cho_o,

    -- 3. ANH/ CHỊ/ EM RUỘT THỨ 1
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Sibling’s full name):', 2), '<', 1)) AS ace1_ho_ten,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Year of birth):', 4), '<', 1)) AS ace1_nam_sinh,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Occupation):', 4), '<', 1)) AS ace1_nghe_nghiep,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Company’s name):', 4), '<', 1)) AS ace1_co_quan,

    -- 4. ANH/ CHỊ/ EM RUỘT THỨ 2
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Sibling’s full name):', 3), '<', 1)) AS ace2_ho_ten,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Year of birth):', 5), '<', 1)) AS ace2_nam_sinh,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Occupation):', 5), '<', 1)) AS ace2_nghe_nghiep,
    TRIM(SPLIT_PART(SPLIT_PART(REPLACE(db_link.link_remarks, '&#160;', ' '), 'Company’s name):', 5), '<', 1)) AS ace2_co_quan

FROM db_link
WHERE
    db_link.source_pk = 'VJC4679'
    AND db_link.source_type = 'SG'
    AND db_link.description = 'PERSONAL_INFO_RELATIVES'