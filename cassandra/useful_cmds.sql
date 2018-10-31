stores user-password in this table
select * from system_auth.credentials; 

partitioner:
============
 The partitioner is responsible for distributing groups of rows (by partition key) .
types:
-----
 Murmur3Partitioner,RandomPartitioner, ByteOrderedPartitioner, and
 OrderPreservingPartitioner.

data Storage location:
----------------
		/var/lib/cassandra/data

commit log:
------------
		/var/lib/cassandra/commitlog


start the db:
=============
service cassandra/dse start


Check Cluster status:
==========================
sudo nodetool status

UN==> Up and Normal.

cqlsh:
------
cqlsh -u bheri -p 1234

show host;

show version;

ctrl+l-->to clear screen

Initial settings
=====================
list users;  --displays all users

for user creation:
------------------

vi /etc/cassandra/cassandra.yaml
search for /authenticator

change authenticator: AllowAllAuthenticator To authenticator: PasswordAuthenticator 

change authorizer: AllowAllAuthorizer To authorizer: CassandraAuthorizer

sudo service cassandra restart

cqlsh localhost -u cassandra -p cassandra

create user bheri with password '1234' superuser;

for permissions:
----------------
search for authorizer in cassandra.yaml

change authorizer: AllowAllAuthorizer TO authorizer: org.apache.cassandra.auth.CassandraAuthorizer

grant all permissions on all keyspaces to bheri;

list all permissions of bheri;

User Creation
==============
CREATE USER bheri WITH PASSWORD '123456' SUPERUSER;

ALTER USER bheri WITH PASSWORD '1234' NOSUPERUSER;

DROP USER bheri

LIST ALL PERMISSIONS; --Lists all users permissions
LIST ALL PERMISSIONS OF bheri;
LIST ALL PERMISSIONS ON bheri.student;   -- all permisions of student table fro user bheri

GRANT ALL PERMISSIONS ON ravens.plays TO boone;

GRANT SELECT/MODIFY/ALTER/AUTHORIZE ON ALL KEYSPACES TO hari;  (AUTHORIZE for granting and revoking permissions)

GRANT SELECT/MODIFY/ALTER ON KEYSPACE student_db TO hari;

--------------------------------------------------------------------------------------
REVOKE ( permission_name PERMISSION ) | ( REVOKE ALL PERMISSIONS )ON resource FROM user_name

REVOKE SELECT ON bheri.student FROM hari; (here bheri,hari are users)

Cluster-->Keyspace-->column family(tables):
=============================================

Keyspace:
=========

Syntax:
	CREATE KEYSPACE “KeySpace Name”
	WITH replication = {'class': ‘Strategy name’, 'replication_factor' : ‘No.Of  replicas’}
	AND durable_writes = ‘Boolean value’;

CREATE KEYSPACE bheri WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 2 };

DESCRIBE keyspaces;

SELECT * FROM system.schema_keyspaces;

DROP KEYSPACE bheri;

CREATE KEYSPACE bheri WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'dc1' : 2 };


SELECT * FROM system_schema.keyspaces;
---------------------------------------

 keyspace_name      | durable_writes | replication
--------------------+----------------+-------------------------------------------------------------------------------------
              bheri |           True |       {'class': 'org.apache.cassandra.locator.NetworkTopologyStrategy', 'dc1': '2'}
        system_auth |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '1'}
      system_schema |           True |                             {'class': 'org.apache.cassandra.locator.LocalStrategy'}
 system_distributed |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '3'}
             system |           True |                             {'class': 'org.apache.cassandra.locator.LocalStrategy'}
      system_traces |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '2'}




CAPTURE   --concatanaes o/p of query to file
---------
 capture '/home/srihari/Desktop/Cassandra/captr'
select * from books;



allow filtering:
----------------
select * from books where id(non-pkey)='2' allow filtering;

capture off;

consistency   --displays consistency level

update consistency level
------------------------
consistency TWO/SERIAL/QUORUM

----------

copy:
----
CAPTURE '/home/Desktop/user.csv';
select * from user;
Now capturing query output to '/home/Desktop/user.csv'.


cqlsh -10.0.2.15 -e'SELECT * FROM bheri.contactbook' > /~/Desktop/output.csv

cqlsh -u cassandra -p c@ss@ndr@212 173.231.191.212 -e 'select * from im_cass_mesh.glcat_altmcat where fk_glcat_mcat_id in (9,23)' > /home/sumit/1.csv

COPY books (id,year) TO '/home/srihari/Desktop/Cassandra/copy_file' WITH HEADER = TRUE;

COPY contactbook (fk_glusr_usr_id,contacts_glid, im_contact_id,last_contact_date) from '/home/srihari/Desktop/Cassandra/bheri.csv';

source:  can run the queries from a file
-------
	source '/home/srihari/Desktop/Cassandra/queries';

describe cluster;	-- lists all clusters
describe keyspaces;	-- lists all keyspaces
describe tables;	-- lists all tables
describe table books;   -- describes a table
DESCRIBE TYPES;		-- lists all user-defined types
describe type card_details; -- descibes a particular type

LIST USERS

Expand: row-wise data
------
	expand on;
	expand off;

csql
-----
use bheri;


CREATE TABLE books (id int PRIMARY KEY, title text, year text);

ALTER TABLE books ADD emp_email text;
ALTER TABLE books DROP emp_email;


ALTER TABLE cycling.cyclist_alt_stats ADD favorite_color varchar; 
ALTER TABLE cycling.cyclist_alt_stats ALTER favorite_color TYPE text;

CREATE TABLE timeseries (
  event_type text,
  insertion_time timestamp,
  event blob,
  PRIMARY KEY (event_type, insertion_time)
)
WITH CLUSTERING ORDER BY (insertion_time DESC);


DROP TABLE books

TRUNCATE books

CREATE INDEX name ON books (id);

drop index name;

INSERT INTO books (id,title,year) VALUES(1,'ram', 100);


UPDATE books SET title='seetha',year='1001' WHERE id=2;

del column:
-----------
 DELETE year FROM books WHERE id=3;

del row:
---------
DELETE FROM emp WHERE emp_id=3;

select token(stuid) from student;
python -c "print [str(((2**64 / number_of_tokens) * i) - 2**63) for i in range(number_of_tokens)]"


all_columns:
==============
select * FROM   system.schema_columns where keyspace='bheri';

m--views:
========
CREATE MATERIALIZED VIEW mv_books AS SELECT *  FROM books WHERE title is not null PRIMARY KEY(id);


BATCH : Using BATCH, you can execute multiple modification statements (insert, update, delete) simultaneiously.
=====
		 BEGIN BATCH
			INSERT INTO emp (emp_id, emp_city, emp_name, emp_phone, emp_sal) values(  4,'Pune','rajeev',9848022331, 30000);
			UPDATE emp SET emp_sal = 50000 WHERE emp_id =3;
			DELETE emp_city FROM emp WHERE emp_id = 2;
		APPLY BATCH;

collections:
===========
	list:  order of elemenets will maintain
	----
		CREATE TABLE mailing (name text PRIMARY KEY, email list<text>);
		INSERT INTO mailing  (name, email) VALUES ('hari', ['bheri.bheri@gmail.com','bherisrihari@gmail.com']);
		UPDATE emailing SET email = email +['srihari@indiamart.com'] where name='hari';

	set:
	----
		CREATE TABLE mobile (hari text PRIMARY KEY, phone set<varint>);
		INSERT INTO mobile(name, phone)VALUES ('bheri',    {9848022338,9848022339});
		UPDATE mobile SET phone = phone + {9848022330} where name = 'bheri';

	map: (key,value)
	----------------	
		 CREATE TABLE address (name text PRIMARY KEY, address map<timestamp, text>);
		
		INSERT INTO address (name, address) VALUES ('hari', {'home' : 'hyderabad' , 'office' : 'Delhi' } );
		
		UPDATE addres SET address = address+{'office':'banglore'} WHERE name = 'hari';

user-defined data type:
=======================

CREATE TYPE emp_details (num int,pin int,name text,cvv int, phone set<int>);

ALTER TYPE emp_details ADD email text;

describe type emp_details;

ALTER TYPE typename RENAME existing_name TO new_name;

drop type card;


mviews
======
student(id,name p.key (id));

desc materialized view student_mv;

create materialized view student_mv as select * from student where name is not null primary key (id,name);

table stats
===========
nodetool cfstats clickstream.freeshowroomurl_glid_mapping;


SELECT dateof(now()) FROM system.local ;
SELECT dateof(now()) FROM system.local ;


==============
--user-defined functions:

cahnge in yaml file

enable_user_defined_functions=true

create table games (name text primary key,when int,scores set<int>);
INSERT INTO games (name , when, scores ) VALUES ( 'cricket', 1, {1,2,65,32,981,91 }); 


CREATE OR REPLACE FUNCTION setTotal(input set<int>) RETURNS NULL ON NULL INPUT RETURNS int LANGUAGE java AS '    
               int total = 0;
               for (Object i : input) { total += (Integer) i; }
               return total;
            ';

CREATE OR REPLACE FUNCTION getMax(input set<int>) RETURNS NULL ON NULL INPUT RETURNS int LANGUAGE java AS '    
                int max = Integer.MIN_VALUE;
                for (Object i : input) { max = Math.max(max, (Integer) i); }
                return max;
            ';


cqlsh:bheri> select name,when,setTotal(scores) from games;

 name    | when | bheri.settotal(scores)
---------+------+------------------------
 cricket |    1 |                   1172



CREATE OR REPLACE FUNCTION getMax(input set<int>) RETURNS NULL ON NULL INPUT RETURNS int LANGUAGE java AS '    
                int max = Integer.MIN_VALUE;
                for (Object i : input) { max = Math.max(max, (Integer) i); }
                return max;
            ';
select getMax({1,2,3,4})


CREATE FUNCTION add ( val1 double, val2 double )
    RETURNS double LANGUAGE java
    BODY
        return (val1 == null || val2 == null) ? null : Double.valueOf( val1.doubleValue() + val2.doubleValue() );
    END BODY;


CREATE FUNCTION bheri ( val1 double, val2 double )
    RETURNS double LANGUAGE java
    BODY
        return (val1 == null || val2 == null) ? null : Double.valueOf( val1.doubleValue() + val2.doubleValue() );
    END BODY;



--Triggers
==========

