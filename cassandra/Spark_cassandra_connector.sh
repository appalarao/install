spark cassandra connector
=========================
sudo wget http://apache.uib.no/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz

sudo tar -xvzf spark-2.2.1-bin-hadoop2.7.tgz


export SPARK_HOME=/usr/local/spark-2.0.2-bin-hadoop2.6
export PATH=$SPARK_HOME/bin:$PATH


=======================================================================

http://blog.einext.com/apache-cassandra/query-cassandra-tables-using-spark

cd spark-2.2.1-bin-hadoop2.7

bin/spark-shell --packages com.datastax.spark:spark-cassandra-connector_2.11:2.0.0-M3 --conf spark.cassandra.connection.host=10.0.2.15

val student = spark.read.format("org.apache.spark.sql.cassandra").
    options(Map( "table" -> "bheri3", "keyspace" -> "bheri")).
    load()

val course = spark.read.format("org.apache.spark.sql.cassandra").
    options(Map( "table" -> "course", "keyspace" -> "bheri")).
    load()

student.show()

course.show()


student.registerTempTable("student")

course.registerTempTable("course")


sql("select a.id, a.cid, a.name, b.course_id, b.cname from student a join course b on a.cid = b.course_id ").show()


sql("select cid,count(1) from student group by cid").show()
====================================================================================
new ips

1.104.196.179.97  10.142.0.2

2.35.231.57.203   10.142.0.3

3. 35.196.20.195   10.142.0.5

rm -rf /var/lib/cassandra/data/system/*


#change dc name of everynode in below file
vi cassandra-rackdc.properties
dc=dc1
rack=rack1


cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.2,10.142.0.3
listen_address: 10.142.0.2
rpc_address: 10.142.0.2
endpoint_snitch: GossipingPropertyFileSnitch

cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.2,10.142.0.3
listen_address: 10.142.0.3
rpc_address: 10.142.0.3
endpoint_snitch: GossipingPropertyFileSnitch

cluster_name: 'bheri_Cluster'
num_tokens: 256
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        - seeds: 10.142.0.2,10.142.0.3
listen_address: 10.142.0.5
rpc_address: 10.142.0.5
endpoint_snitch: GossipingPropertyFileSnitch





nodetool listsnapshots

nodetool clearsnapshot

nodetool snapshot im_cass_mesh

20--1522733702891
21--1522733723162
22--1522733731040
23--1522733736259
24--1522733740944

cd /opt1/cassandra/data/im_cass_mesh/glcat_mcat-7dd931d0f71811e5a50bafbd9a9ff964/snapshots

scp 1522733740944/* cassandra@173.231.179.142:/opt1/cassandra/data/im_cass_mesh/glcat_mcat-a70fa41033fe11e8926dfda86b82bf89

sumit@123



nodetool refresh im_cass_mesh glcat_mcat

student-1f054a30ab9411e88279e7f24dee0bc8
student-1f054a30ab9411e88279e7f24dee0bc8
student-1f054a30ab9411e88279e7f24dee0bc8

================================================================================================

1.104.196.179.97  10.142.0.2

2.35.231.57.203   10.142.0.3

3. 35.196.20.195   10.142.0.5





wget http://www.scala-lang.org/files/archive/scala-2.10.1.tgz

tar xvf scala-2.10.1.tgz

sudo mv scala-2.10.1 /usr/lib

sudo ln -s /usr/lib/scala-2.10.1 /usr/lib/scala

export PATH=$PATH:/usr/lib/scala/bin


scala -version

Scala code runner version 2.10.1 -- Copyright 2002-2013, LAMP/EPFL

wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.7.tgz

tar xf spark-2.0.0-bin-hadoop2.7.tgz
mkdir /usr/local/spark
cp -r spark-2.0.0-bin-hadoop2.7/* /usr/local/spark

export SPARK_EXAMPLES_JAR=/usr/local/spark/examples/jars/spark-examples_2.11-2.0.0.jar
PATH=$PATH:$HOME/bin:/usr/local/spark/bin
source ~/.bash_profile

root@vnode ~]# spark-shell

spark-shell --packages com.datastax.spark:spark-cassandra-connector_2.11:2.0.0-M3 --conf spark.cassandra.connection.host=10.142.0.2
==========================================================

10.142.0.2  #master
10.142.0.3  #worker
10.142.0.5  #worker
========================

jps - Java Virtual Machine Process Status Tool

#master-node
cd /usr/local/spark/conf

vi spark-env.sh
#add at below
SPARK_MASTER_HOST='10.142.0.2'

cd ../sbin
./start-master.sh

jps

#slave node configuration

cd /usr/local/spark/conf
vi spark-env.sh
SPARK_MASTER_HOST='10.142.0.2'

cd ../sbin
./start-slave.sh spark://<your.master.ip.address>:7077

./start-slave.sh spark://10.142.0.2:7077



val student = spark.read.format("org.apache.spark.sql.cassandra").
    options(Map( "table" -> "student", "keyspace" -> "srihari", "username" -> "bheri" ,"password" -> "1234")).
    load()


student.show()

course.show()


student.registerTempTable("student")

course.registerTempTable("course")


sql("select a.id, a.cid, a.name, b.course_id, b.cname from student a join course b on a.cid = b.course_id ").show()


sql("select cid,count(1) from student group by cid").show()



spark-shell --packages com.datastax.spark:spark-cassandra-connector_2.11:2.0.0-M3 --conf spark.cassandra.connection.host=10.142.0.5

