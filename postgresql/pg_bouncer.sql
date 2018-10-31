PG_Bouncer
==========
-PgBouncer is a lightweight connection pooler for PostgreSQL.

-It creates connections and assign incoming connections requests to it in a first-come-first served manner.

Check users list:
------------------
compgen -u

sudo chown -R user-name /path_to_folder


-sudo apt-get install postgresql-server-dev-9.6
-sudo apt-get install libevent-dev
-sudo apt-get install pgbouncer


Creating Database Authentication File for PgBouncer
-----------------------------------------------------
PgBouncer is not part of PostgreSQL server. 
Being a third party software we need to provide the list of database users along with encrypted passwords to it, 
so that PgBouncer can authenticate the clients requesting for a pooled resource. 
This also implies that that whenever a new database user is created the user list also must be updated in pgbouncer.ini
Run the following query in a query browser or terminal as "postgres" user to generate the user list for PgBouncer:

sudo su - postgres

psql -U postgres -d postgres
COPY (SELECT '"' || rolname || '" "' ||CASE WHEN rolpassword IS null THEN '' ELSE rolpassword END || '"' FROM pg_authid) TO '/etc/pgbouncer/userlist.txt';

Configuring pgbouncer.ini
---------------------------
cd /etc/pgbouncer/

sudo su postgres
vi /etc/pgbouncer/pgbouncer.ini


	Configuring the Database
	-------------------------
	In the [database] section of the pgbouncer.ini file we have to map our database for which we want to enable pooling. 
		As an example, add the below line under [database] to map the default database – postgres:

	list of users+dbs that needs to be connect from pgbouncer:

	postgres = host=localhost

	bheri_db=host=localhost port=5432 dbname=postgres

	
	Changing the Listen Address
	---------------------------
	Under the section [pgbouncer], we have specify the IP address to which the PgBouncer daemon should listen to. 
		
	listen_addr = *

	Setting the auth_type
	---------------------
	This setting is similar to the pg_hba.conf file of PostgreSQL server. Setting this to md5, will force the client to use passwords, and PgBouncer will use the userlist.txt we created in step 1.

	auth_type = md5

********Setting the admin_users
	-----------------------
	We have to provide one or more database users for PgBouncer to use with whenever the admin console of PgBouncer is accessed. The following will suffice for now:

	admin_users = postgres

	Setting the max_client_conn
	---------------------------
	max_client_conn is the number of clients that can connect to the pool at any instance. The default is 100. 
	max_client_conn = 500

	Setting the default_pool_size and reserve_pool_size
	---------------------------------------------------
	These two setting are per user/database pair. default_pool_size determines how many server connections to allow per each user/database combination.
	reserve_pool_size is the number of additional connections to allow in case of any trouble. 
	Again, these settings are the core of the PgBouncer and you should come up with an optimum figure to be used based on the nature of your application.
	
	default_pool_size = 20
	reserve_pool_size = 5

	Save the file and exit vi.

sudo service pgbouncer start


on error
====================================================================
Run the command to open pgbouncer initialization script:

sudo gedit /etc/init.d/pgbouncer

Replace the following part:

case "$1" in
  start)
    # Check if we are still disabled in /etc/default/pgbouncer
    [ "${START:-}" = "0" ] && exit 0
    log_daemon_msg "Starting PgBouncer" $NAME
    test -d $PIDDIR || install -d -o postgres -g postgres -m 2775 $PIDDIR
    $SSD --start --chuid $RUNASUSER --oknodo -- $OPTS 2> /dev/null
    log_e
    ;;
To:

case "$1" in
 start)
 log_daemon_msg "Starting PgBouncer" $NAME
 test -d $PIDDIR || install -d -o postgres -g postgres -m 2775 $PIDDIR
 $SSD --start --chuid $RUNASUSER --oknodo -- $OPTS 2&gt; /dev/null
 log_end_msg $?
 ;;

Save it and try to start the service again


======================================================================

Connect to pg_bouncer:6432
--------------------------
psql -p 6432 -h localhost postgres(same name in the config file of pgbouncer)
psql -p 6432 -h localhost -U postgres bheri_db

psql -p 6432 -h localhost -U postgres pgbouncer


Monitoring
----------
PgBouncer provides an administration console through which we can list the server connections and clients, and also evaluate the health of Pool.
For this we have to connect to a special pseudo database named pgbouncer as follows:

psql -p 6432 -h localhost -d pgbouncer

psql -p 6432 -h localhost -U postgres pgbouncer

psql -p 6432 -h localhost -U postgres bheri_db (user must be in admin_users of pgbouncer.ini)


Listing server connections
---------------------------
SHOW SERVERS;

SHOW CLIENTS;



References:
----------
http://technobytz.com/install-configure-pgbouncer-pooling-in-postgresql-1.html
https://pgbouncer.github.io/config.html
