export JAVA_HOME=/usr/java/jdk1.8.0_161/

bin/spark-shell --packages com.datastax.spark:spark-cassandra-connector_2.11:2.0.0-M3 --conf spark.cassandra.connection.host=173.231.179.142

val paid_url_glid_mapping = spark.read.format("org.apache.spark.sql.cassandra").
    options(Map( "table" -> "paidshowroomurl_glid_mapping", "keyspace" -> "clickstream")).
    load()

val free_url_glid_mapping = spark.read.format("org.apache.spark.sql.cassandra").
    options(Map( "table" -> "freeshowroomurl_glid_mapping", "keyspace" -> "clickstream")).
    load()

paid_url_glid_mapping.show()

free_url_glid_mapping.show()


paid_url_glid_mapping.registerTempTable("paid_url_glid_mapping")

free_url_glid_mapping.registerTempTable("free_url_glid_mapping")


sql("select a.id, a.cid, a.name, b.course_id, b.cname from student a join course b on a.cid = b.course_id ").show()


sql("select glusr_usr_id,count(1) from paid_url_glid_mapping group by glusr_usr_id").show()



sql("select a.glusr_usr_id, a.freeshowroom_url, b.glusr_usr_id, b.paidshowroom_url from free_url_glid_mapping a join paid_url_glid_mapping b on a.glusr_usr_id = b.glusr_usr_id ").show()




export JAVA_HOME=/usr/java/jdk1.8.0_161/
cd ~/spark-2.2.0-bin-hadoop2.7/

./bin/pyspark


df = spark.createDataFrame([('Male', 67, 150), # insert column values
                            ('Female', 65, 135),
                            ('Female', 68, 130),
                            ('Male', 70, 160),
                            ('Female', 70, 130),
                            ('Male', 69, 174),
                            ('Female', 65, 126),
                            ('Male', 74, 188),
                            ('Female', 60, 110),
                            ('Female', 63, 125),
                            ('Male', 70, 173),
                            ('Male', 70, 145),
                            ('Male', 68, 175),
                            ('Female', 65, 123),
                            ('Male', 71, 145),
                            ('Male', 74, 160),
                            ('Female', 64, 135),
                            ('Male', 71, 175),
                            ('Male', 67, 145),
                            ('Female', 67, 130),
                            ('Male', 70, 162),
                            ('Female', 64, 107),
                            ('Male', 70, 175),
                            ('Female', 64, 130),
                            ('Male', 66, 163),
                            ('Female', 63, 137),
                            ('Male', 65, 165),
                            ('Female', 65, 130),
                            ('Female', 64, 109)], 
                           ['gender', 'height','weight']) # insert header values


df.show(5) --fetches 5 records


from pyspark.sql import functions
df = df.withColumn('gender',functions.when(df['gender']=='Female',0).otherwise(1))
df = df.select('height', 'weight', 'gender')
df.show()
+------+------+------+
|height|weight|gender|
+------+------+------+
|    67|   150|     1|
|    65|   135|     0|
|    68|   130|     0|
|    70|   160|     1|
|    70|   130|     0|
|    69|   174|     1|
|    65|   126|     0|
|    74|   188|     1|
|    60|   110|     0|
|    63|   125|     0|
|    70|   173|     1|
|    70|   145|     1|
|    68|   175|     1|
|    65|   123|     0|
|    71|   145|     1|
|    74|   160|     1|
|    64|   135|     0|
|    71|   175|     1|
|    67|   145|     1|
|    67|   130|     0|
+------+------+------+
only showing top 20 rows

val a = Array("apple", "banana", "orange")

for (e <- a) println(e)



for (e <- a) {
        val s = e.toUpperCase
        println(s)
      }

for (i <- 1 to 10 if i < 4) println(i)



CREATE TABLE clickstream.bheri (
    id int PRIMARY KEY,
    name text
)



import org.apache.spark.sql._
import sqlContext.implicits._
import com.datastax.spark.connector.streaming._
import com.datastax.spark.connector._

case class WordCount(id: Int, name: String)

for (i <- 1 to 10000000) 
{
	val collection = sc.parallelize(Seq(WordCount(i,"abcd")))
      --val collection = sc.parallelize(Seq(WordCount(1,"a"),WordCount(2,"b"),WordCount(3,"c")))
	collection.saveToCassandra("clickstream", "bheri", SomeColumns("id", "name"))
}


---------------------------
import org.apache.spark.sql._
import sqlContext.implicits._
import com.datastax.spark.connector.streaming._
import com.datastax.spark.connector._


case class Person(firstname:String, age:Int, lastname:String)


val sqlContext = new org.apache.spark.sql.SQLContext(sc)
val person = sc.textFile("/home/sumit/student1.csv")


val rowRDD = person.map(_.split(";")).map(p => Person(p(0),p(1).toInt,p(2)))
rowRDD.saveToCassandra("clickstream","student", SomeColumns("firstname", "age", "lastname"))











-------------------------------------------------------------------------------------------------------------------------------------------------------------------
val sqlContext = new org.apache.spark.sql.SQLContext(sc)
val student = sc.textFile("/home/sumit/student.csv")

import org.apache.spark.sql._
import sqlContext.implicits._
import org.apache.spark.sql.types.{StructType, StructField, StringType, IntegerType};


val schema =  StructType(Array(StructField("firstname",StringType,true),StructField("lastname",StringType,true),StructField("age",IntegerType,true)))
val rowRDD = student.map(_.split(";")).map(p => org.apache.spark.sql.Row(p(0),p(1),p(2).toInt))


val studentDF = sqlContext.applySchema(rowRDD, schema)
studentDF.write.format("org.apache.spark.sql.cassandra").options(Map( "table" -> "student", "keyspace" -> "clickstream")).save()



import sqlContext.implicits._
import sqlContext.implicits._



val sqlContext = new org.apache.spark.sql.SQLContext(sc)
val student = sc.textFile("/home/sumit/student.csv")

import org.apache.spark.sql._
import org.apache.spark.sql.types.{StructType, StructField, StringType, IntegerType};


case class Person(firstname:String, lastname:String, age:Int)
val rowRDD = person.map(_.split(",")).map(p => Person(p(0),p(1),p(2).toInt)
rowRDD.saveToCassandra(clickstream, student)










-------------------------------------------------------------------------------------------------------------------------------------------------------------------



val employeeDF = sqlContext.createDataFrame(rowRDD, schema)

employeeDF.registerTempTable("employee")

val allrecords = sqlContext.sql("SELECT * FROM employee")


=============================================================================================================================================================================================================
val sqlContext = new org.apache.spark.sql.SQLContext(sc)

val student = sc.textFile("/home/sumit/student.csv")

import org.apache.spark.sql._

import org.apache.spark.sql.types.{StructType, StructField, StringType, IntegerType};


val schema =  StructType(Array(StructField("firstname",StringType,true),StructField("lastname",StringType,true),StructField("age",IntegerType,true)))

val rowRDD = student.map(_.split(",")).map(p ⇒ org.apache.spark.sql.Row(p(0),p(1),p(2).toInt))

val studentDF = sqlContext.applySchema(rowRDD, schema)


studentDF.registerTempTable("student")

val allrecords = sqlContext.sql("SELECT * FROM student")

allrecords.show()
==================================================================

val sqlContext = new org.apache.spark.sql.SQLContext(sc)

val employee = sc.textFile("employee.txt")

val df = sqlContext.read().format("com.databricks.spark.csv").option("inferScheme","true").option("header","true").load("/home/sumit/student1.csv");


val schemaString = "id name age"

import org.apache.spark.sql.Row;
import org.apache.spark.sql.types.{StructType, StructField, StringType};

val schema = StructType(schemaString.split(" ").map(fieldName ⇒ StructField(fieldName, StringType, true)))

val rowRDD = employee.map(_.split(",")).map(e ⇒ Row(e(0).trim.toInt, e(1), e(2).trim.toInt))

 val employeeDF = sqlContext.createDataFrame(rowRDD, schema)

employeeDF.registerTempTable("employee")

val allrecords = sqlContext.sql("SELECT * FROM employee")


allrecords.show()







val df = sqlContext.read().format("com.databricks.spark.csv").load("/home/sumit/student1.csv");



case class Product(sku: String, description: String, countPerPack: Int)
 
// read the lines of the file as text
val rawTextRDD = sc.textFile("/home/sumit/student.csv")
 
// map each line from the raw text to a Product 
val productsRDD = rawTextRDD.map{       raw_line => 
            val columns = raw_line.split(";")
 
            Product(columns(0), columns(1), columns(2).toInt)
 
} 
// optional: convert the RDD to a data frame
val productDF = productsRDD.toDF
productDF.show
