csdb2-dl-->206.191.151.200 #master   Vn333Raamkua
192.170.156.88
192.170.156.94
206.191.151.201
192.170.156.84 



wget http://www.scala-lang.org/files/archive/scala-2.10.1.tgz

tar xvf scala-2.10.1.tgz

sudo mv scala-2.10.1 /usr/lib

sudo ln -s /usr/lib/scala-2.10.1 /usr/lib/scala

vi ~/.bash_profile

export PATH=$PATH:/usr/lib/scala/bin

source ~/.bash_profile
scala -version

wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.7.tgz

tar xf spark-2.0.0-bin-hadoop2.7.tgz
mkdir /usr/local/spark
cd spark-2.0.0-bin-hadoop2.7
cp -r * /usr/local/spark

export SPARK_EXAMPLES_JAR=/usr/local/spark/examples/jars/spark-examples_2.11-2.0.0.jar
export SPARK_HOME=/usr/local/spark
export PATH=$SPARK_HOME/bin:$PATH
PATH=$PATH:$HOME/bin:/usr/local/spark/bin
source ~/.bash_profile

root@vnode ~]# spark-shell

spark-shell --packages com.datastax.spark:spark-cassandra-connector_2.11:2.0.0-M3 --conf spark.cassandra.connection.host=206.191.151.200


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


=============================================================================================================================================================================================================
spark-shell --packages com.datastax.spark:spark-cassandra-connector_2.11:2.0.0-M3

sc.stop
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.sql.SQLContext
import com.datastax.spark.connector._
val conf = new SparkConf(true).set("spark.cassandra.connection.host", "10.142.0.2,10.142.0.3").set("spark.cassandra.auth.username", "cassandra").set("spark.cassandra.auth.password", "cassandra")
val sc = new SparkContext(conf)
val sqlContext = new SQLContext(sc)
val student = sqlContext.read.format("org.apache.spark.sql.cassandra").options(Map("table" -> "student", "keyspace" -> "bheri")).load.cache()
student.count()
student.show()


cassandra





clickstream




spark-shell --packages com.datastax.spark:spark-cassandra-connector_2.11:2.0.0-M3

spark-shell --packages com.datastax.spark:spark-cassandra-connector_2.11:2.0.0-M3 --num-executors 4 --executor-cores 2 --executor-memory 6G

sc.stop
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.sql.SQLContext
import com.datastax.spark.connector._
val conf = new SparkConf(true).set("spark.cassandra.connection.host", "206.191.151.200").set("spark.cassandra.auth.username", "cassandra").set("spark.cassandra.auth.password", "c@ss@ndr@212")
val conf = new SparkConf(true).set("spark.cassandra.connection.host", "206.191.151.200,192.170.156.88,192.170.156.94,206.191.151.201,192.170.156.84 ").set("spark.cassandra.auth.username", "cassandra").set("spark.cassandra.auth.password", "c@ss@ndr@212")
val sc = new SparkContext(conf)

val sqlContext = new SQLContext(sc)
val df = sqlContext.read.format("org.apache.spark.sql.cassandra").options(Map("table" -> "gl_city", "keyspace" -> "clickstream")).load.cache()
df.count()
df.show()



val glcity = sqlContext.read.format("org.apache.spark.sql.cassandra").options(Map("table" -> "gl_city", "keyspace" -> "clickstream")).load.cache()

val glusr = sqlContext.read.format("org.apache.spark.sql.cassandra").options(Map("table" -> "glusr_usr", "keyspace" -> "clickstream")).load.cache()

glusr.registerTempTable("glusr")

glcity.registerTempTable("glcity")

sqlContext.sql("select a.glusr_usr_id,b.gl_city_name from glusr a join glcity b on a.FK_GL_CITY_ID = b.GL_CITY_ID and a.glusr_usr_id=236").show()

sqlContext.sql("select gl_city_name from glcity where GL_CITY_ID=73765 ").show()





sqlContext.sql("select glusr_usr_email from glusr where glusr_usr_id=236").show


glusr.registerTempTable("glusr_usr")

val data = sqlContext.sql("select username from users where username = 'tc'")



glcity.registerTempTable("glcity")










BEGIN BATCH
INSERT INTO bheri.student (id, name) VALUES (uuid(), 'random');
INSERT INTO bheri.student (id, name) VALUES (uuid(), 'random');
INSERT INTO bheri.student (id, name) VALUES (uuid(), 'random');
till 1000 times
APPLY BATCH;
