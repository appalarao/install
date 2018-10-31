white-listing
--------------

node-1:  10.0.2.4
	sudo iptables -A INPUT -p tcp -s 10.0.2.15   -m multiport --dports 5432,6432 -m state --state NEW,ESTABLISHED -j ACCEPT

	sudo iptables -L

node-2:  10.0.2.15
	sudo iptables -A INPUT -p tcp -s 10.0.2.4   -m multiport --dports 5432,6432 -m state --state NEW,ESTABLISHED -j ACCEPT
	sudo iptables -L


--reference

https://wiki.postgresql.org/wiki/Streaming_Replication

--masster node
==============
sudo mkdir /var/lib/pgsql/10/data/wal_archives_loc --directory to store archival files

sudo chown -R postgres:postgres /var/lib/pgsql/10/data/wal_archives_loc



--vi postgresql.conf:
======================

listen_addresses = '*'

archive_mode = on

archive_command = 'cp "%p" /var/lib/pgsql/10/data/wal_archives_loc/"%f"'

archive_command = 'cp "%p" /wal_files/"%f"'

wal_level = 'hot_standby' 

max_wal_senders = 100  --sending processes

wal_keep_segments = 2000 --max arch. files to keep  



create user/alter user for replication
=======================================

CREATE ROLE bheri WITH REPLICATION PASSWORD '1234' LOGIN
or 
create user bheri with password '1234'

ALTER USER bheri REPLICATION

--pg_hba.conf
------------
TYPE  DATABASE        USER            ADDRESS                 METHOD
host  replication     indiamart     slave-node/32              md5





--slave-node
============
sudo systemctl stop postgresql

sudo rm -rf /var/lib/pgsql/10/data/

inital back_up
--------------
sudo su postgres

pg_basebackup -h 192.168.0.10(master node) -U indiamart -D /var/lib/postgresql/10/main -U replication --xlog-method=stream
or
pg_basebackup -h 10.142.0.28 -U bheri -D /var/lib/pgsql/10/data -X stream --progress --verbose -c fast

/****** stop the rest if u want to continue this as write node **********/

postgresql.conf
---------------
hot_standby=on

wal_level = 'hot_standby'


getting data from wal_files_location
====================================

--create recovery.conf file in data directory

sudo vim /var/lib/pgsql/10/main/recovery.conf

recovery.conf
---------------
standby_mode='on'

primary_conninfo='host=master-node port=5432 user=indiamart password=1234'

trigger_file ='/var/lib/pgsql/10/trigger'  #fail over when master is fail this will acts as master

restore_command='cp /var/lib/pgsql/10/data/wal_archives_loc/%f "%p"'   #copies from archive directory

sudo systemctl start postgresql

