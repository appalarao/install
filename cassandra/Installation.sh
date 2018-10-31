###################cnt-os############################

#java installation
#8.0.131
wget --no-cookies --no-check-certificate --header "Cookie:oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
yum -y localinstall jdk-8u131-linux-x64.rpm

vi ~/.bash_profile

export JAVA_HOME=/usr/java/jdk1.8.0_131/
export JRE_HOME=/usr/java/jdk1.8.0_131/jre



#8.0.171 for > cassandra 5.0
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.rpm"

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk8-downloads-2133151.html; oraclelicense=accept-securebackup-cookie;" "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.rpm"

yum -y localinstall jdk-8u171-linux-x64.rpm

vi ~/.bash_profile

export JAVA_HOME=/usr/java/jdk1.8.0_171-amd64/
export JRE_HOME=/usr/java/jdk1.8.0_171-amd64/jre


#RELOAD
source ~/.bash_profile
java -version
############################################################################################################################################

#add repo at yum
vim /etc/yum.repos.d/datastax.repo

#community
[datastax]
name = DataStax Repo of Apache Cassandra
baseurl = http://rpm.datastax.com/community
enabled = 1
gpgcheck = 0

#enterprise edition
[datastax] 
name = DataStax Repo of DataStax Enterprise
baseurl=https://dsa_email_address:password@rpm.datastax.com/enterprise
enabled=1
gpgcheck=0

#indiamart
[datastax]
name = DataStax Repo for DataStax Enterprise
baseurl=http://Indiamart_Intermesh_Ltd:MTX3LTTPD3kEhAB@rpm.datastax.com/enterprise
enabled=1
gpgcheck=0

#apache cassandra
[cassandra]
name=Apache Cassandra
baseurl=https://www.apache.org/dist/cassandra/redhat/311x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.apache.org/dist/cassandra/KEYS


yum list dsc*/dse*

yum install dsc30

service dse/cassandra start

systemctl enable cassandra
###################################################################################################################################################
Cluster formation
=================

service cassandra stop

rm -rf /var/lib/cassandra/data/system/*


#change dc name of everynode in below file
vi cassandra-rackdc.properties
dc=dc1
rack=rack1

dc-1
====

cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.4,10.142.0.5
listen_address: 10.142.0.4
rpc_address: 10.142.0.4
endpoint_snitch: GossipingPropertyFileSnitch


cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.4,10.142.0.5
listen_address: 10.142.0.5
rpc_address: 10.142.0.5
endpoint_snitch: GossipingPropertyFileSnitch


cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.2,10.142.0.3
listen_address: 10.142.0.4
rpc_address: 10.142.0.4
endpoint_snitch: GossipingPropertyFileSnitch


dc-2
====

cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.4,10.142.0.5
listen_address: 10.142.0.5
rpc_address: 10.142.0.5
endpoint_snitch: GossipingPropertyFileSnitch

cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.4,10.142.0.5
listen_address: 10.142.0.6
rpc_address: 10.142.0.6
endpoint_snitch: GossipingPropertyFileSnitch

cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.4,10.142.0.5
listen_address: 10.142.0.7
rpc_address: 10.142.0.7
endpoint_snitch: GossipingPropertyFileSnitch



dc-3
====

cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.8,10.142.0.9
listen_address: 10.142.0.8
rpc_address: 10.142.0.8
endpoint_snitch: GossipingPropertyFileSnitch


cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.8,10.142.0.9
listen_address: 10.142.0.9
rpc_address: 10.142.0.9
endpoint_snitch: GossipingPropertyFileSnitch


########################################################################ubuntu########################################################################

sudo apt-get install default-jdk

echo "deb http://www.apache.org/dist/cassandra/debian 36x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.list

gpg --keyserver pgp.mit.edu --recv-keys 749D6EEC0353B12C
gpg --export --armor 749D6EEC0353B12C | sudo apt-key add -

sudo apt-get update

sudo apt-get install cassandra


install cassandra-python driver:
-------------------------------
sudo apt install python-pip
pip install cassandra-driver
export CQLSH_NO_BUNDLED=true


cassandra-env.sh
JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname=10.0.2.15"


Cassandra-cluster:
=================
export CQLSH_NO_BUNDLED=true

sudo service cassandra stop

sudo rm -rf /var/lib/cassandra/data/system/*

whitelisting the servers:
-------------------------
	node-1:  10.0.2.4
		sudo iptables -A INPUT -p tcp -s 10.0.2.15   -m multiport --dports 7000,9042 -m state --state NEW,ESTABLISHED -j ACCEPT

		sudo iptables -L

	node-2:  10.0.2.15
		sudo iptables -A INPUT -p tcp -s 10.0.2.4   -m multiport --dports 7000,9042 -m state --state NEW,ESTABLISHED -j ACCEPT
		sudo iptables -L

sudo service cassandra stop

node-1:

cluster_name: 'bheri_cluster'  
num_tokens: 256  
seed_provider:  
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
      parameters:
          - seeds: "10.0.2.15,10.0.2.4"

listen_address: 10.0.2.4
broadcast_address: 10.0.2.4
rpc_address: 0.0.0.0  
broadcast_rpc_address: 10.0.2.4

node-2:

cluster_name: 'bheri_cluster'  
num_tokens: 256  
seed_provider:  
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
      parameters:
          - seeds: "10.0.2.15,10.0.2.4"

listen_address: 10.0.2.15
broadcast_address: 10.0.2.15
rpc_address: 0.0.0.0  
broadcast_rpc_address: 10.0.2.15

sudo service cassandra start


#########################################################################################################
vi /etc/cassandra/default.conf/cassandra-env.sh

Now find the following line in configuration.
# JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname=<public name>"
Uncomment the line and change its value form <public_name> to the localhost IP address 127.0.0.1.
The configuration should look like shown below.
JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname=127.0.0.1"
Save the file and exit from editor, restart Apache Cassandra by running the following command.
systemctl restart cassandra

