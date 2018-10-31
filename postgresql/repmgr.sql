[jensd@pgdb1 ~]$ sudo yum install -y http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/repmgr94-2.0.2-4.rhel7.x86_64.rpm
yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm

yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/repmgr10-4.0.6-1.rhel7.x86_64.rpm


yum install repmgr10


cluster=db_cluster
node_id=1
data_directory ='/var/lib/pgsql/10/data'
node_name=instance-1
conninfo='host=10.142.0.2 user=repmgr dbname=repmgr'
pg_bindir=/usr/pgsql-10/bin/
master_response_timeout=5
reconnect_attempts=2
reconnect_interval=2
failover=manual
promote_command='/usr/pgsql-10/bin/repmgr standby promote -f /var/lib/pgsql/repmgr/repmgr.conf'
follow_command='/usr/pgsql-10/bin/repmgr standby follow -f /var/lib/pgsql/repmgr/repmgr.conf'
=====================================

CREATE ROLE pgpool SUPERUSER CREATEDB CREATEROLE INHERIT REPLICATION LOGIN ENCRYPTED PASSWORD 'secret';

CREATE USER repmgr SUPERUSER LOGIN ENCRYPTED PASSWORD 'secret';

CREATE DATABASE repmgr OWNER repmgr;






master:
ssh srihari@35.229.36.95
10.142.0.2


slave:
ssh srihari@35.231.179.74
10.142.0.3

pgpool:
ssh srihari@35.190.176.106
10.142.0.4





/usr/pgsql-10/bin/repmgr -f /var/lib/pgsql/repmgr/repmgr.conf master register


host    repmgr          repmgr      192.168.202.101/32  trust
host    replication     repmgr      192.168.202.101/32  trust


host    repmgr          repmgr      192.168.202.102/32  trust
host    replication     repmgr      192.168.202.102/32  trust


host    all             pgpool      192.168.202.103/32  trust
host    all             all         192.168.202.103/32  md5



slave-node

/usr/pgsql-10/bin/repmgr -D /var/lib/pgsql/10/data -d repmgr -p 5432 -U repmgr -R postgres standby clone 10.142.0.2

node-2:
======

/var/lib/pgsql/repmgr/repmgr.conf

cluster=db_cluster
node_id=2
data_directory ='/var/lib/pgsql/10/data'
node_name=instance-2
conninfo='host=10.142.0.3 user=repmgr dbname=repmgr'
pg_bindir=/usr/pgsql-10/bin/
master_response_timeout=5
reconnect_attempts=2
reconnect_interval=2
failover=manual
promote_command='/usr/pgsql-10/bin/repmgr standby promote -f /var/lib/pgsql/repmgr/repmgr.conf'
follow_command='/usr/pgsql-10/bin/repmgr standby follow -f /var/lib/pgsql/repmgr/repmgr.conf'

====================================

sudo chown postgres:postgres /var/lib/pgsql/repmgr/repmgr.conf


/usr/pgsql-10/bin/repmgr -f /var/lib/pgsql/repmgr/repmgr.conf standby register


service postgresql-10 start

/usr/pgsql-10/bin/repmgr -f /var/lib/pgsql/repmgr/repmgr.conf standby register

/usr/pgsql-10/bin/repmgr -f /var/lib/pgsql/repmgr/repmgr.conf standby register -F


sudo su - postgres -c " /usr/pgsql-10/bin/repmgr -f /var/lib/pgsql/repmgr/repmgr.conf cluster show"









PGpool:
=======


master:
ssh srihari@35.229.36.95
10.142.0.2


slave:
ssh srihari@35.231.179.74
10.142.0.3

pgpool:
ssh srihari@35.190.176.106
10.142.0.4


yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm

yum install postgresql10 pgpool-II-10 -y

sudo cp /etc/pgpool-II-10/pgpool.conf.sample-stream /etc/pgpool-II-10/pgpool.conf

vi /etc/pgpool-II-10/pgpool.conf

listen_addresses = '*'
port = 5432
backend_hostname0 = '10.142.0.2'
backend_port0 = 5432
backend_weight0 = 1
backend_data_directory0 = '/var/lib/pgsql/10/data'
backend_flag0 = 'ALLOW_TO_FAILOVER'

backend_hostname1 = '10.142.0.3'
backend_port1 = 5432
backend_weight1 = 1
backend_data_directory1 = '/var/lib/pgsql/10/data'
backend_flag1 = 'ALLOW_TO_FAILOVER'


enable_pool_hba = on

pid_file_name = '/var/run/pgpool-II-10/pgpool.pid'
sr_check_user = 'pgpool'
sr_check_password = 'secret'
health_check_period = 10
health_check_user = 'pgpool'
health_check_password = 'secret'
failover_command = '/etc/pgpool-II-10/failover.sh %d %H'  
recovery_user = 'pgpool'
recovery_password = 'secret'
recovery_1st_stage_command = 'basebackup.sh'




vi /etc/pgpool-II-10/failover.sh

#!/bin/sh
failed_node=$1
new_master=$2
(
date
echo "Failed node: $failed_node"
set -x
/usr/bin/ssh -T -l postgres $new_master "/usr/pgsql-9.4/bin/repmgr -f /var/lib/pgsql/repmgr/repmgr.conf standby promote 2>/dev/null 1>/dev/null <&-"
exit 0;
) 2>&1 | tee -a /tmp/pgpool_failover.log

sudo chmod 755 /etc/pgpool-II-10/failover.sh





vi  /etc/pgpool-II-10/pool_hba.conf

TYPE  DATABASE    USER        CIDR-ADDRESS          METHOD
local   all         all                               trust
host    all         all         127.0.0.1/32          trust
host    all         all         ::1/128               trust
host    all         all         0.0.0.0/0             md5


===========================================================================


sudo touch /etc/pgpool-II-10/pool_passwd

sudo chown postgres:postgres /etc/pgpool-II-10/pool_passwd


echo "pgpool:$(pg_md5 secret)"|sudo tee /etc/pgpool-II-10/pcp.conf

sudo systemctl enable pgpool-II-10

sudo systemctl start pgpool-II-10


psql -U pgpool --host pgpool --dbname postgres -c "\list"


ssh srihari@35.231.19.99

ssh srihari@35.196.202.19
