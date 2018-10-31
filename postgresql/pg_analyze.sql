page-www.pganalyze.com
user-srihari@indiamart.com
pwd-IM@1234

CREATE USER pganalyze WITH PASSWORD '1234' CONNECTION LIMIT 10;


CREATE SCHEMA pganalyze;
GRANT USAGE ON SCHEMA pganalyze TO pganalyze;
REVOKE ALL ON SCHEMA public FROM pganalyze;

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

CREATE OR REPLACE FUNCTION pganalyze.get_stat_statements(showtext boolean = true) RETURNS SETOF pg_stat_statements AS
$$
  /* pganalyze-collector */ SELECT * FROM public.pg_stat_statements(showtext);
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION pganalyze.get_stat_activity() RETURNS SETOF pg_stat_activity AS
$$
  /* pganalyze-collector */ SELECT * FROM pg_catalog.pg_stat_activity;
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION pganalyze.get_column_stats() RETURNS SETOF pg_stats AS
$$
  /* pganalyze-collector */ SELECT schemaname, tablename, attname, inherited, null_frac, avg_width,
  n_distinct, NULL::anyarray, most_common_freqs, NULL::anyarray, correlation, NULL::anyarray,
  most_common_elem_freqs, elem_count_histogram
  FROM pg_catalog.pg_stats;
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION pganalyze.get_stat_replication() RETURNS SETOF pg_stat_replication AS
$$
  /* pganalyze-collector */ SELECT * FROM pg_catalog.pg_stat_replication;
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION pganalyze.get_stat_progress_vacuum() RETURNS SETOF pg_stat_progress_vacuum AS
$$
  /* pganalyze-collector */ SELECT * FROM pg_catalog.pg_stat_progress_vacuum;
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;


CREATE OR REPLACE FUNCTION pganalyze.reset_stat_statements() RETURNS SETOF void AS
$$
  /* pganalyze-collector */ SELECT * FROM public.pg_stat_statements_reset();
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

--install collector

echo "[pganalyze_collector]
name=pganalyze_collector
baseurl=https://packages.pganalyze.com/el/6
repo_gpgcheck=1
enabled=1
gpgkey=https://packages.pganalyze.com/pganalyze_signing_key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300" >> /etc/yum.repos.d/pganalyze_collector.repo

yum makecache
yum install pganalyze-collector

--Configuring the collector

vi /etc/pganalyze-collector.conf


[pganalyze]
api_key: HQWXGWEZZ7HVJL3A

[server]
db_host: 63.251.238.77
db_name: imbuyreq
db_username: pganalyze
db_password: 1234



--test
pganalyze-collector --test

--reload
pganalyze-collector --reload















------------------------------------------------------------------------------------------------------------------------------------------------------------
site-https://app.pgdash.io
user-srihari@indiamart.com
pwd-Indiamart@1234


# get pgmetrics
curl -O -L https://github.com/rapidloop/pgmetrics/releases/download/v1.4.2/pgmetrics_1.4.2_linux_amd64.tar.gz

# unpack pgmetrics
tar xvf pgmetrics_1.4.2_linux_amd64.tar.gz

# get pgdash CLI
curl -O -L https://github.com/rapidloop/pgdash/releases/download/v1.3.1/pgdash_1.3.1_linux_amd64.tar.gz

# unpack pgdash CLI
tar xvf pgdash_1.3.1_linux_amd64.tar.gz

# invoke pgmetrics
./pgmetrics_1.4.2_linux_amd64/pgmetrics --help

./pgmetrics_1.4.2_linux_amd64/pgmetrics --no-password imbuyreq


./pgmetrics_1.4.2_linux_amd64/pgmetrics --no-password -f json imbuyreq | ./pgdash_1.3.1_linux_amd64/pgdash -a qhw6C1QWgfFZ34wD9H5RRL report enq_dev_pg




--------------------------------------------------------------------------------------------------------------------------------------------------------------------

https://app.opsdash.com/
Indiamart@1234


tee /etc/yum.repos.d/rapidloop.repo <<EOF
[rapidloop]
name=RapidLoop Public YUM Repository
baseurl=https://packages.rapidloop.com/centos
gpgkey=https://packages.rapidloop.com/gpg-pubkey-rapidloop.asc  
EOF

wget https://packages.rapidloop.com/gpg-pubkey-rapidloop.asc

rpm --import gpg-pubkey-rapidloop.asc

yum install opsdash-smart-agent

vim /etc/opsdash/agent.cfg

service opsdash-agent start


create user opsdash superuser unencrypted password '1234';

vi /etc/opsdash/agent.cfg



apikey = "nLZ7BrQr6sbWO8W0Pdawsi"

service "dev_enq-pg" {
    type = "postgresql"
    host = "63.251.238.77"
    user = "opsdash"
    pass = "1234"
    db = "imbuyreq"
}

