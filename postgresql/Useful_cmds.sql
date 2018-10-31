status:
=======
/etc/init.d/postgresql status

DB creation:
============
CREATE DATABASE bheri WITH ENCODING='UTF8' OWNER=postgres CONNECTION LIMIT=25;



ALTER DATABASE bheri RENAME TO hari;

ALTER DATABASE bheri OWNER TO hari;

DROP DATABASE bheri;

user-creation:
==============
create user bheri with password '1234'

ALTER USER bheri WITH PASSWORD '54321'; --chnage password

ALTER USER imenq WITH PASSWORD 'enqdb4iil';

DROP USER bheri

super-user:
===========
alter user hari superuser;
alter user hari nosuperuser;

coping db/data (with in same server:)
================

CREATE DATABASE temp WITH TEMPLATE bheri;


create database bheri owner=indiamart
========================================
pg_dump bheri > bheri.sql
=================================
psql -d ahri  -f bheri.sql


=================================

(diff servers:)
================

	pg_dump -U user_name -O db_name file.sql  (copy to file)


pg_dump -U indiamart -O bheri bheri.sql

	copy file.sql to desired server.

	psql -U user_name -d db_name -f sourcedb.sql  (copyfrom file)

pg_dump -t glusr_usr imbuyreq -U indiamart -W > bheri_new.sql
pg_dump --schema-only -t glusr_usr -t c2c_records -t iil_inbox_enquiry -t pns_call_records imbuyreq -U indiamart -W > bheri_new.sql

psql -U indiamart -d bheri -f bheri_new.sql

From csv file to table:
=========================
\copy glusr_usr from '/opt2/csv_files/bheri.csv' DELIMITER ',' null as ' ' csv ;

COPY "glusr_contactbook" TO '/opt1/edb_ppas/PostgresPlus/9.5AS/glusr_contactbook.csv';


to reload config files:
========================
/usr/bin/pg_ctl reload
or
SELECT pg_reload_conf();


size of table,database,index:
==================================
SELECT pg_relation_size('tablename'); --bytes (table only)

SELECT pg_size_pretty (pg_relation_size('tablename')); --kB, MB, GB or TB

select pg_size_pretty( pg_total_relation_size('dir_query'));

SELECT pg_size_pretty (pg_total_relation_size ('actor'));  --toatal table size inclu  index,trigger..


SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database;

SELECT pg_size_pretty (pg_indexes_size('actor'));

SELECT pg_size_pretty (pg_tablespace_size ('pg_default'));

--SIZE OF PARTITION TABLE

select sum(to_number(pg_size_pretty(pg_total_relation_size(inhrelid::regclass)),'999999999')) from pg_inherits where inhparent='glusr_contactbook'::regclass;



top 10 heavy tables:
====================

select * from 
(
SELECT relname AS "relation", pg_size_pretty(pg_relation_size(C.oid)) AS "size"
FROM pg_class C LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
WHERE nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_relation_size(C.oid) DESC
)tbl where relation='dirq_mcid_idx1'
LIMIT 10;


SELECT
    table_name,
    pg_size_pretty(table_size) AS table_size,
    pg_size_pretty(indexes_size) AS indexes_size,
    pg_size_pretty(total_size) AS total_size
FROM (
    SELECT
        table_name,
        pg_table_size(table_name) AS table_size,
        pg_indexes_size(table_name) AS indexes_size,
        pg_total_relation_size(table_name) AS total_size
    FROM (
        SELECT ('"' || table_schema || '"."' || table_name || '"') AS table_name
        FROM information_schema.tables
    ) AS all_tables
    ORDER BY total_size DESC
) AS pretty_sizes limit 10;






SELECT pg_size_pretty (pg_relation_size('tablename'));

show max_locks_per_transaction;

select count(1) from pg_locks,pg_class where oid=relation ;

Commands:
==========
export EDITOR=vim/vi/geditor/nano (on machine)
\e	--for editor

\set	--System variables list.

\?	-- help

\timing		--timing on

\l 	--list all dbs

\d table_name  --particular table

\dE or \det --list of foreign tables

\d 	--all tables

\du 	--lists all users

\dn	--List schemas

\df	--List functions

\dv   	--List views

\s 	--sql history
\dT	--list TYPES
\s filename  --export sql history to a file

\i filename   --execute psql commands from a file

\H 	--ouput in HTML
\dx	--installed extensions
\q 	--quit


SELECT prosrc FROM pg_proc WHERE proname = 'procname'   --Show stored procedure source

SELECT * FROM pg_stat_activity;  --View Database Connections:

SELECT pg_terminate_backend(pg_stat_activity.pid)   --TO KILL A PROCESS

SELECT * from pg_catalog.pg_attribute ;

ddl of table
================
pg_dump -U bheri -h localhost postgres -s -t student -f tab.sql

ddl of function
================
\pset format wrapped
select pg_get_functiondef(oid) from pg_proc where proname ='emp';

SELECT pg_get_indexdef('demo_pkey'::regclass);

select * from pg_available_extensions;

select * from pg_foreign_server;



Foreign table creation:
============================
1.Create the remote server
2.Create a user mapping for the remote server
3.Create your foreign tables
4.Start querying some things

Postgresql foreign-data-wraper
==============================
CREATE EXTENSION postgres_fdw;

CREATE SERVER bheri_serv FOREIGN DATA WRAPPER postgres_fdw OPTIONS (dbname 'test', host 'localhost');

CREATE USER MAPPING for bheri(postgres-user) SERVER bheri_serv OPTIONS (user 'bheri', password '1234');

CREATE USER MAPPING for INDIAMART SERVER edb OPTIONS (user 'indiamart', password 'blalrtdb4iil');

CREATE FOREIGN TABLE bheri(id integer) SERVER bheri_serv OPTIONS (table_name 'bheri');

DROP EXTENSION postgres_fdw;

DROP SERVER IF EXISTS bheri_serv;

DROP USER MAPPING IF EXISTS FOR bheri SERVER bheri_serv;

DROP FOREIGN TABLE bheri;

ALTER SERVER bheri_serv OPTIONS (host 'localhost', dbname 'xe');

ALTER USER MAPPING FOR bheri SERVER bheri_serv OPTIONS (user 'bheri', password '123456');



Oracle foreign-data-wraper
==============================
CREATE EXTENSION oracle_fdw;

CREATE SERVER ENQ_Readonly FOREIGN DATA WRAPPER oracle_fdw OPTIONS (dbserver '//ora17-dl.intermesh.net/imenq');

GRANT USAGE ON FOREIGN SERVER ENQ_Readonly TO indiamart;

CREATE USER MAPPING FOR indiamart SERVER ENQ_Readonly OPTIONS (user 'imenq', password 'enqdb4iil');

CREATE FOREIGN TABLE QUOTATIONS_ATTACHMENT
(
QUOTATIONS_ATTACHMENT_ID  numeric(10) NOT NULL,
FK_IIL_RFQ_QUOTATION_ID      numeric(10) NOT NULL,
DATE_UPLOAD             timestamp without time zone,
IIL_RFQ_QUOTATION_ATTACHMENT text not null
) 
SERVER ENQ_Readonly OPTIONS (table 'QUOTATIONS_ATTACHMENT');

select t.relname,l.locktype,page,virtualtransaction,pid,mode,granted from pg_locks l, pg_stat_all_tables t where l.relation=t.relid and t.relname='eto_unsold_dir_query_mvw' order by relation asc;

select t.relname,l.locktype,page,virtualtransaction,pid,transactionid,mode,granted from pg_locks l, pg_stat_all_tables t where l.relation=t.relid and lower(mode) like '%exclusive%' order by relation asc;

SELECT pg_terminate_backend(pid) ;

select pg_cancel_backend(pid);--preferable

select query,backend_start,xact_start,query_start from pg_stat_activity where pid=27364

select view_definition, replace(substr(view_definition,strpos(view_definition,'FROM')+5),';','') from INFORMATION_SCHEMA.views WHERE table_name = 'glcat_mcat';

select UPPER(to_char(date_trunc('month', current_date) + (interval '1' month * generate_series(-17,0)) ,'mon-yy')) adate

get clients address
===================
select inet_client_addr();

stats
=====
select * from pg_stat_all_tables;

show track_commit_timestamp;

restart the machine;

SELECT pg_xact_commit_timestamp(xmin), * FROM  YOUR_TABLE_NAME;

SELECT pg_xact_commit_timestamp(xmin), * FROM YOUR_TABLE_NAME where COLUMN_NAME=VALUE;


privilages
==========

CREATE SEQUENCE seq_glusr_contact_labels 
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

ALTER TABLE glusr_contact_labels ALTER COLUMN glusr_contact_label_id SET DEFAULT nextval('seq_glusr_contact_labels');


ALTER TABLE IIL_INBOX_ENQUIRY ALTER COLUMN iil_enquiry_thread_count SET DEFAULT 1;


ALTER TABLE message_center_detail alter column message_attachment5_url type character varying(1000)

insert into glusr_contact_labels (fk_glusr_usr_id, glusr_contact_label_name, fk_iil_color_master_id) values(53701209, 'follow-up', 2);

grant execute on function fn_get_snippet() to enquiry;
GRANT USAGE, SELECT ON SEQUENCE seq_glusr_contact_labels TO enquiry;
ALTER TABLE pns_call_records OWNER TO pns;
--grant on fdw-server
CREATE USER MAPPING FOR enquiry SERVER enq_r OPTIONS (user 'imenq', password 'enqdb4iil');

terminal view:
==============
\pset format wrapped
db=# \x
Expanded display is on.


\a --aligned format

\e --goto vi mode and run the function with spaces
=================================
SELECT
  relname,
  seq_scan - idx_scan AS too_much_seq,
  CASE
    WHEN
      seq_scan - coalesce(idx_scan, 0) > 0
    THEN
      'Missing Index?'
    ELSE
      'OK'
  END,
  pg_relation_size(relname::regclass) AS rel_size, seq_scan, idx_scan
FROM
  pg_stat_all_tables /pg_stat_user_tables
WHERE
  schemaname = 'public'
  AND pg_relation_size(relname::regclass) > 80000
ORDER BY
  too_much_seq DESC;
=======================================================================


VACUUM (FULL, VERBOSE, ANALYZE) dir_query_reply
it will shrink both table and accociated index by deleting dead tuples;

select * from pg_stat_user_tables where relname='dir_query_reply';

REINDEX INDEX my_index;


mviews
======
REFRESH MATERIALIZED VIEW view_name;

	--When you refresh data for a materialized view, PosgreSQL locks the entire table therefore you cannot query data against it. To avoid this, you can use the CONCURRENTLY option.

REFRESH MATERIALIZED VIEW CONCURRENTLY view_name;

--With CONCURRENTLY option, PostgreSQL creates a temporary updated version of the materialized view, compares two versions, and performs INSERT and UPDATE only the differences.
--You can query against the materialized view while it is being updated. 
--One requirement for using CONCURRENTLY option is that the materialized view must have a UNIQUE index

-----------------------------
--check privilages of tables and sequences

CREATE OR REPLACE FUNCTION table_privs(text) RETURNS table(username text, relname regclass, privs text[])
AS
$$
SELECT  $1,c.oid::regclass, array(select privs from unnest(ARRAY [ 
( CASE WHEN has_table_privilege($1,c.oid,'SELECT') THEN 'SELECT' ELSE NULL END),
(CASE WHEN has_table_privilege($1,c.oid,'INSERT') THEN 'INSERT' ELSE NULL END),
(CASE WHEN has_table_privilege($1,c.oid,'UPDATE') THEN 'UPDATE' ELSE NULL END),
(CASE WHEN has_table_privilege($1,c.oid,'DELETE') THEN 'DELETE' ELSE NULL END),
(CASE WHEN has_table_privilege($1,c.oid,'TRUNCATE') THEN 'TRUNCATE' ELSE NULL END),
(CASE WHEN has_table_privilege($1,c.oid,'TRIGGER') THEN 'TRIGGER' ELSE NULL END)]) foo(privs) where privs is not null)
 FROM pg_class c JOIN pg_namespace n on c.relnamespace=n.oid where n.nspname not in ('information_schema','pg_catalog','sys')  and c.relkind='r' and
has_table_privilege($1,c.oid,'SELECT, INSERT,UPDATE,DELETE,TRUNCATE,TRIGGER') AND has_schema_privilege($1,c.relnamespace,'USAGE')
$$ language sql;


CREATE OR REPLACE FUNCTION seq_privs(text) RETURNS table(username text, relname regclass, privs text[])
AS
$$

SELECT  $1,c.oid::regclass, array(select privs from unnest(ARRAY [ 
( CASE WHEN has_sequence_privilege($1,c.oid,'SELECT') THEN 'SELECT' ELSE NULL END)
]) foo(privs) where privs is not null)
 FROM pg_class c JOIN pg_namespace n on c.relnamespace=n.oid where n.nspname not in ('information_schema','pg_catalog','sys')  and c.relkind='S' and
has_sequence_privilege($1,c.oid,'SELECT') AND has_schema_privilege($1,c.relnamespace,'USAGE')
$$ language sql;




SELECT  'gladmin',c.oid::regclass, array(select privs from unnest(ARRAY [ 
( CASE WHEN has_table_privilege('gladmin',c.oid,'SELECT') THEN 'SELECT' ELSE NULL END),
(CASE WHEN has_table_privilege('gladmin',c.oid,'INSERT') THEN 'INSERT' ELSE NULL END),
(CASE WHEN has_table_privilege('gladmin',c.oid,'UPDATE') THEN 'UPDATE' ELSE NULL END),
(CASE WHEN has_table_privilege('gladmin',c.oid,'DELETE') THEN 'DELETE' ELSE NULL END),
(CASE WHEN has_table_privilege('gladmin',c.oid,'TRUNCATE') THEN 'TRUNCATE' ELSE NULL END),
(CASE WHEN has_table_privilege('gladmin',c.oid,'TRIGGER') THEN 'TRIGGER' ELSE NULL END)]) foo(privs) where privs is not null)
 FROM pg_class c JOIN pg_namespace n on c.relnamespace=n.oid where n.nspname not in ('information_schema','pg_catalog','sys')  and c.relkind='r' and
has_table_privilege('gladmin',c.oid,'SELECT, INSERT,UPDATE,DELETE,TRUNCATE,TRIGGER') AND has_schema_privilege('gladmin',c.relnamespace,'USAGE')



SELECT pg_relation_filepath('dir_query');

--remove psqlhistory
vi /var/lib/pgsql/.psql_history




select count(1) from pg_indexes where tablename in (select relname from pg_stat_user_tables)

select schemaname, viewname from pg_catalog.pg_views
where schemaname NOT IN ('pg_catalog', 'information_schema')
order by schemaname, viewname;

select 'select pg_terminate_BACKEND('||PID||');' from pg_stat_activity where client_addr='192.170.156.81' and query='unlisten *';

 /usr/pgsql-9.3/bin/pg_ctl -D /var/lib/pgsql/9.3/data stop -m fast



pg_blocked query
================
SELECT blocked_locks.pid     AS blocked_pid,
blocked_activity.usename  AS blocked_user,
blocking_locks.pid     AS blocking_pid,
blocking_activity.usename AS blocking_user,
blocked_activity.query    AS blocked_statement,
blocking_activity.query   AS current_statement_in_blocking_process
FROM  pg_catalog.pg_locks         blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks         blocking_locks
ON blocking_locks.locktype = blocked_locks.locktype
AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.GRANTED;
