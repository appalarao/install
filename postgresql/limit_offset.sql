select QUERY_ID from 
(
select QUERY_ID,row_number() over() rn
FROM
 DIR_QUERY left outer join (SELECT * FROM GLUSR_FOLDER_TO_DIR_QUERY WHERE FK_GLUSR_USR_ID = 236 AND QUERY_TYPE = 'W'
 ) GLUSR_FOLDER_TO_DIR_QUERY 
on QUERY_ID = GLUSR_FOLDER_TO_DIR_QUERY.FK_DIR_QUERY_ID
WHERE QUERY_RCV_GLUSR_USR_ID = 236 and query_rcv_glusr_usr_id%100=36
) tbl
--where rn>100 and rn<150;
limit 49 offset 100

limit /*howmany_rows*/ offset --starting value;
