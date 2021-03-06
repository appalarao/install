cd /bin


./spark-shell


val textFile = sc.textFile("/opt2/README.md") # Create an RDD called tTextFile


get options by 

textFile +tab

textFile.take(7) -- Returns the top 7 lines from the file as an Array of Strings

scala> textFile.take(7)
res5: Array[String] = Array(# Apache Spark, "", Spark is a fast and general cluster computing system for Big Data. It provides, high-level APIs in Scala, Java, Python, and R, and an optimized engine that, supports general computation graphs for data analysis. It also supports a, rich set of higher-level tools including Spark SQL for SQL and DataFrames,, MLlib for machine learning, GraphX for graph processing,)




scala> textFile.count()
res4: Long = 103



scala> textFile.filter(line => line.contains("please")).count() 
res2: Long = 0

scala> textFile.filter(line => line.contains("Please")).count() 
res3: Long = 4



--Python shell examples


./bin/pyspark

--no need of val
textFile = sc.textFile("README.md") //Create and RDD called textFile by reading the contents of README.md file

textFile.take(7)

