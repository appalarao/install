##Check For Previous Installed Version
yum list installed | grep post

#To Prevent Postgres To Auto-Upgrade
#Add exclude to /etc/yum.repos.d/CentOS-Base.repo file [base] and [updates] sections:

Bash
[base]
...
exclude=postgresql*
[updates]
...
exclude=postgresql*

##Install PostgreSQL 9.4 with YUM:
yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-3.noarch.rpm

yum install https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm

yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos10-10-3.noarch.rpm



https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/postgresql96-9.6.9-1PGDG.rhel7.x86_64.rpm

https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/postgresql96-server-9.6.9-1PGDG.rhel7.x86_64.rpm

https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/postgresql96-contrib-9.6.9-1PGDG.rhel7.x86_64.rpm

https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/postgresql96-devel-9.6.9-1PGDG.rhel7.x86_64.rpm

https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/postgresql96-libs-9.6.9-1PGDG.rhel7.x86_64.rpm


postgresql10.x86_64                                                                                       10.5-1PGDG.rhel7                                                                           @pgdg10
postgresql10-devel.x86_64                                                                                 10.5-1PGDG.rhel7                                                                           @pgdg10
postgresql10-libs.x86_64                                                                                  10.5-1PGDG.rhel7                                                                           @pgdg10
postgresql10-plperl.x86_64                                                                                10.5-1PGDG.rhel7                                                                           @pgdg10
postgresql10-plpython.x86_64                                                                              10.5-1PGDG.rhel7                                                                           @pgdg10
postgresql10-server.x86_64





#List Packages
yum list postgresql*

#Install Postgres DB Server and Other Required Packages
yum install postgresql10 postgresql10-server 

yum install postgresql96 postgresql96-server postgresql96-contrib postgresql96-devel postgresql96-plperl postgresql96-plpython

yum install postgresql11 postgresql11-libs postgresql11-server postgresql11-contrib postgresql11-devel

 postgresql96-plperl postgresql96-plpython

#After Installation Check If User's been created
compgen -u
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#<Optional Steps For Keeping The Data on User Defined Location>#
cd /var/lib/pgsql/10

rm data
ln -s /opt1/postgres/data data

ln -s /opt1/v_11/data data

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Initialize The Database in The Default Directory /var/lib/pgsql/9.6/data
su - postgres -c /usr/pgsql-10/bin/initdb
su - postgres -c /usr/pgsql-11/bin/initdb

su - postgres -c /usr/pgsql-9.6/bin/initdb

#Switch To Postgres User
su - postgres

#Start The Cluster
/usr/pgsql-10/bin/pg_ctl -D /var/lib/pgsql/10/data -l /var/lib/pgsql/10/data/logfile start/stop

systemctl start postgresql-10
#Configure PostgreSQL 10 For Accepting Connection on All IPs
vi /var/lib/pgsql/10/data/postgresql.conf
listen_addresses = '*'

#Allow Specific Hosts
vi /var/lib/pgsql/9.6/data/pg_hba.conf

#Enable Postgres Service To Start by Default at System Startup
systemctl enable postgresql-10.service

systemctl status postgresql-10.service









export PGDATA=/opt1/postgres/data

/usr/pgsql-9.6/bin/pg_ctl -D /opt1/pg_data/data start


/usr/bin/pg_ctl -D /opt1/pg_data/data status

/usr/pgsql-9.6/bin/pg_ctl -D /opt1/pg_data/data status


##################################################################################################################################################

#######php-driver for postgresql################

sudo apt-get install apache2

sudo apt-get install php libapache2-mod-php

sudo apt-get install php-pgsql

######################################
Oracle-client
#############
git clone https://github.com/haribheri/oracle_client.git

yum install oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
yum install oracle-instantclient11.2-basiclite-11.2.0.4.0-1.x86_64.rpm
yum install oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
yum install oracle-instantclient11.2-jdbc-11.2.0.4.0-1.x86_64.rpm
yum install oracle-instantclient11.2-odbc-11.2.0.4.0-1.x86_64.rpm
yum install oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm
yum install oracle-instantclient11.2-tools-11.2.0.4.0-1.x86_64.rpm


vi ~/.bash_profile

export ORACLE_HOME=/usr/lib/oracle/11.2/client64
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export TNS_ADMIN=/usr/lib/oracle/11.2/client64
export PATH=$PATH:$ORACLE_HOME/bin:$LD_LIBRARY_PATH

export PATH=$PATH:/usr/pgsql-9.6/bin

source ~/.bash_profile

Install Mysql_fdw:
##################
yum install mysql

yum install mysql-devel

git clone https://github.com/EnterpriseDB/mysql_fdw.git

make USE_PGXS=1

make USE_PGXS=1 install

/sbin/ldconfig /usr/lib64/mysql/libmysqlclient.so

CREATE EXTENSION mysql_fdw;

CREATE SERVER mysql_server
     FOREIGN DATA WRAPPER mysql_fdw
     OPTIONS (host '127.0.0.1', port '3306');

CREATE USER MAPPING FOR postgres
SERVER mysql_server
OPTIONS (username 'foo', password 'bar');

CREATE FOREIGN TABLE warehouse(
     warehouse_id int,
     warehouse_name text,
     warehouse_created datetime)
SERVER mysql_server OPTIONS (dbname 'db', table_name 'warehouse');



Install Oaracle_fdw:
####################
git clone https://github.com/haribheri/oracle_client.git
su -
export PATH=$PATH:/usr/pgsql-10/bin

cd /opt1/oracle_fdw
make
make install

/sbin/ldconfig /usr/lib/oracle/11.2/client64/lib #reload oracle_client configuration file

su - postgres

create extension oracle_fdw;

#get postgresql-pid environmental variables
cat /proc/1663/environ | xargs -n 1 -0 echo


Install Cassandra-fdw
#####################

yum install postgresql10-devel

yum install postgresql10-common


git clone git://github.com/Kozea/Multicorn.git
cd Multicorn
make && make install

yum install python-devel

yum install python-pip

pip install cassandra-driver

git clone https://github.com/rankactive/cassandra-fdw.git

cd cassandra-fdw

python setup.py install

CREATE SERVER fdw_server FOREIGN DATA WRAPPER multicorn
OPTIONS (
  wrapper 'cassandra-fdw.CassandraFDW',
  hosts '10.142.0.4,10.142.0.5',
  port '9042',
  username 'bheri', 
  password '1234' 
);

CREATE FOREIGN TABLE emp_ft
(
  eid numeric,
  ename text
) SERVER fdw_server OPTIONS (keyspace 'bheri', columnfamily 'emp');



#python program to fetch data from cassandra nodes

from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider

auth_provider = PlainTextAuthProvider(username='srihari', password='123456')
cluster = Cluster(['10.142.0.4,10.142.0.5'],auth_provider = auth_provider)

keyspace='bheri'
conn=cluster.connect(keyspace)

query=conn.execute('select * from student')

for i in query:
	print "id %d and name is %s " %(i.id,i.name)



#hadoop foreign data wrapper

git clone https://github.com/EnterpriseDB/hdfs_fdw.git

