yum install http://www.pgpool.net/yum/rpms/3.7/redhat/rhel-7-x86_64/pgpool-II-release-3.7-1.noarch.rpm


yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
yum install postgresql10
yum install postgresql10-server
yum install postgresql10-contrib

/usr/pgsql-10/bin/initdb

yum install  pgpool-II-10
yum install pgpool-II-pg10-debuginfo
yum install pgpool-II-pg10-devel
yum install pgpool-II-pg10-extensions

cd /etc/pgpool-II-10
cp pgpool.conf.sample-stream pgpool.conf  #conf file

cp pool_hba.conf.sample pool_hba.conf     #auth file


sudo su - postgres 
psql
CREATE ROLE bheri_pgpool SUPERUSER CREATEDB CREATEROLE INHERIT REPLICATION LOGIN ENCRYPTED PASSWORD '123456';
\q
exit 


vi /etc/pgpool-II-10/pgpool.conf 

listen_addresses = '*'
port = 5432


backend_hostname0 = '' #ip of host1
backend_port0 = 5432
backend_weight0 = 1	#only in load balancing mode
backend_data_directory0 = '/var/lib/pgsql/10/data'
backend_flag0 = 'ALLOW_TO_FAILOVER'


backend_hostname1 = ''  #ip of host2
backend_port1 = 5432
backend_weight1 = 1	
backend_data_directory1 = '/var/lib/pgsql/9.5/data'
backend_flag1 = 'ALLOW_TO_FAILOVER'



enable_pool_hba = on   #Use pool_hba.conf for client authentication

pid_file_name = '/var/run/pgpool-II-10/pgpool.pid'

sr_check_user = 'pgpool'	#Streaming replication check user

sr_check_password = 'secret'

#health checkups
health_check_period = 10

health_check_user = 'pgpool'

health_check_password = 'secret'

failover_command = '/etc/pgpool-II-10/failover.sh %d %H'  

failover_command = '/etc/pgpool-II/failover.sh %d %P %H %R'


#failover.sh
=============
#! /bin/sh -x
# Execute command by failover.
# special values:  %d = node id
#                  %h = host name
#                  %p = port number
#                  %D = database cluster path
#                  %m = new master node id
#                  %M = old master node id
#                  %H = new master node host name
#                  %P = old primary node id
#                  %R = new master database cluster path
#                  %r = new master port number
#                  %% = '%' character

falling_node=$1          # %d
old_primary=$2           # %P
new_primary=$3           # %H
pgdata=$4                # %R

pghome=/usr/pgsql-9.6
log=/var/log/pgpool/failover.log

date >> $log
echo "failed_node_id=$falling_node new_primary=$new_primary" >> $log

if [ $falling_node = $old_primary ]; then
    if [ $UID -eq 0 ]
    then
        su postgres -c "ssh -T postgres@$new_primary $pghome/bin/pg_ctl promote -D $pgdata"
    else
        ssh -T postgres@$new_primary $pghome/bin/pg_ctl promote -D $pgdata
    fi
    exit 0;
fi;
exit 0;

====================================================================================

#failover.sh
===========
vi /etc/pgpool-II-10/failover.sh
----------------------------------
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
------------------------------------------------
chmod 755 /etc/pgpool-II-10/failover.sh
=============================================================

recovery_user = 'pgpool'

recovery_password = 'secret'

recovery_1st_stage_command = 'basebackup.sh'


#Errors

sudo mkdir /var/run/pgpool
sudo chmod 777 /var/run/pgpool
sudo chown postgres:postgres /var/run/pgpool
sudo postgresql service restart
