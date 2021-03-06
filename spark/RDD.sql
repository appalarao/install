--In Memory: 
An RDD is a memory-resident collection of objects. We will look at options where an RDD can be stored in memory, on disk, or both. However, the execution speed of Spark stems from the fact that the data is in memory, and is not fetched from disk for each operation.
--Partitioned:
A partition is a division of a logical dataset or constituent elements into independent parts. Partitioning is a defacto performance optimization technique in distributed systems to achieve minimal network traffic, a killer for high performance workloads. The objective of partitioning in key-value oriented data is to collocate a similar range of keys and in effect, minimize shuffling. Data inside RDD is split into partitions and across various nodes of the cluster. Will discuss this in more detail later in this chapter.
--Typed:
Data in an RDD is strongly typed. When you create an RDD, all the elements are typed depending on the data type.
--Lazy evaluation:
The transformations in Spark are lazy, which means data inside RDD is not available until you perform an action. You can, however, make the data available at any time using a count() action on the RDD. Will discuss this later and the benefits associated with it.
--Immutable:
An RDD once created cannot be changed. It can, however, be transformed into a new RDD by performing a set of transformations on it.
Parallel: An RDD is operated on in parallel. Since the data is spread across a cluster in various partitions, each partition is operated on in parallel.
--Cacheable: 
Since RDDs are lazily evaluated, any action on an RDD will cause the RDD to revaluate all transformations that led to the creation of the RDD. This is generally not a desirable behavior on large datasets, and hence Spark allows the option to cache the data on memory or disk. Will discuss caching later in this chapter.
