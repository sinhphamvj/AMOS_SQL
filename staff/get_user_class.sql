SELECT sign.firstname as "FULL NAME",
       tr_participant_list.sign as "ID",
       sign.email as "EMAIL",
       sign.lastname as "POSITION",
       sign.homebase as "STATION",
       tr_course_list.course_name as "COURSE NAME",
       tr_course_list.description as "COURSE DESC"
FROM tr_participant_list
LEFT JOIN tr_course_list ON tr_course_list.course_listno_i = tr_participant_list.course_listno_i
LEFT JOIN sign ON sign.user_sign = tr_participant_list.sign
WHERE tr_participant_list.course_listno_i = 27131  

