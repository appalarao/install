Architecture:
==============
All the nodes in a cluster play the same role. Each node is independent and at the same time interconnected to other nodes.
Each node in a cluster can accept read and write requests, regardless of where the data is actually located in the cluster.
When a node goes down, read/write requests can be served from other nodes in the network.


Cassandra places replicas of data on different nodes based on these two factors.
Replication Strategy:
--------------------
	Where to place next replica is determined by the Replication Strategy.
Replication Factor:
-------------------
	While the total number of replicas placed on different nodes is determined by the Replication Factor.

If replication factor is 2, then it maintains 2 copies of each row, in a different nodes of a cluster.

SimpleStrategy:
--------------
	Used when you have just one data center. 
	SimpleStrategy places the first replica on the node selected by the partitioner. 
	After that, remaining replicas are placed in clockwise direction in the Node ring.

NetworkTopologyStrategy
----------------------

NetworkTopologyStrategy is used when you have more than two data centers.

In NetworkTopologyStrategy, replicas are set for each data center separately. NetworkTopologyStrategy places replicas in the clockwise direction in the ring until reaches the first node in another rack.

This strategy tries to place replicas on different racks in the same data center. This is due to the reason that sometimes failure or problem can occur in the rack. Then replicas on other nodes can provide data.

Here is the pictorial representation of the Network topology strategy




Cassandra is a partitioned row store database, where rows are organized into tables with a required primary key.
Clients read or write requests can be sent to any node in the cluster. 
When a client connects to a node with a request, that node serves as the coordinator for that particular client operation. 
The coordinator acts as a proxy between the client application and the nodes that own the data being requested. 
The coordinator determines which nodes in the ring should get the request based on how the cluster is configured.



Snitches: 
--------
A snitch determines which datacenters and racks nodes belong to. They inform Cassandra about the network topology so that requests are routed efficiently and allows Cassandra to distribute replicas by grouping machines into datacenters and racks. Specifically, the replication strategy places the replicas based on the information provided by the new snitch. All nodes must return to the same rack and datacenter. Cassandra does its best not to have more than one replica on the same rack (which is not necessarily a physical location).


Primary key:
-----------
1. Also called row-key.
2. There are a number of columns in a row but the number of columns can vary in different rows.
	Ex: one row in a table can have three columns whereas another row in the same table can have 10 columns.

Compound Primary Key:
--------------------
1. comprised of one or more columns that are referenced in the primary key. 
   One component of the compound primary key is called partition key, whereas the other component is called the clustering key.

examples:
	C1: Primary key has only one partition key and no cluster key.

	(C1, C2): Column C1 is a partition key and column C2 is a cluster key.

	(C1,C2,C3,…): Column C1 is a partition key and columns C2, C3, and so on make the cluster key.

	(C1, (C2, C3,…)): It is same as 3, i.e., column C1 is a partition key and columns C2,C3,… make the cluster key.

	((C1, C2,…), (C3,C4,…)): columns C1, C2 make partition key and columns C3,C4,… make the cluster key.

Partition Key:
-------------
1. The purpose of a partition key is to identify the partition or node in the cluster that stores that row. 
2. When data is read or written from the cluster, a function called Partitioner is used to compute the hash value of the partition key. 
3. This hash value is used to determine the node/partition which contains that row. 
4. For example, rows whose partition key values range from 1000 to 1234 may reside in node A, 
   and rows with partition key values range from 1235 to 2000 may reside in node B, as shown in figure 1. 
   If a row contains partition key whose hash value is 1233 then it will be stored in node A.









Clustering Key:
--------------
1. The purpose of the clustering key is to store row data in a sorted order. 
2. The sorting of data is based on columns, which are included in the clustering key. 
3. This arrangement makes it efficient to retrieve data using the clustering key.

Examples:
---------

create table student (stuid int, avg_marks float, description text, primary key (stuid));

stuid | avg_marks | description
--------------------------------
1 |      25.5 |   student 1
2 |      35.5 |   student 2

select token(stuid) from student;
Token generation:
-----------------
		python -c "print [str(((2**64 / number_of_tokens) * i) - 2**63) for i in range(number_of_tokens)]"


@ Row 1
———————+———————-
system.token(stuid) | -4069959284402364209
@ Row 2
———————+———————-
system.token(stuid) | -3248873570005575792


create table marks(stuid int,exam_date timestamp,marks float, exam_name text, 
primary key (stuid,exam_date));

stuid | exam_date                | exam_name | marks
-------+--------------------------+-----------+-------
     1 | 2016-11-10 00:00:00+0530 |     examA |    76
     1 | 2016-11-11 00:00:00+0530 |     examB |    90
     1 | 2016-11-12 00:00:00+0530 |     examC |    68
     2 | 2016-11-12 00:00:00+0530 |     examC |    68

select token(stuid) from marks;

@ Row 1
--------------+----------------------
 token(stuid) | -4069959284402364209

@ Row 2
--------------+----------------------
 token(stuid) | -4069959284402364209

@ Row 3
--------------+----------------------
 token(stuid) | -4069959284402364209

@ Row 4
--------------+----------------------
 token(stuid) | -3248873570005575792


******
We can see all the three rows have the same partition token, hence Cassandra stores only one row for each partition key. 
All the data associated with that partition key is stored as columns in the datastore. 
The data that we have stored through three different insert statements have the same stuid value, i.e. 1, 
therefore, all the data is saved in that row as columns, i.e under one partition.

Here,
The Partition Key is responsible for data distribution across your nodes.
The Clustering Key is responsible for data sorting within the partition.


mviews:
========
CREATE MATERIALIZED VIEW mv_books AS SELECT *  FROM books WHERE title is not null PRIMARY KEY(id);

create materialized view student_mv as select * from student where name is not null primary key (id,name);
desc materialized view student_mv;

***
A primary key of a Materialized View can contain at most one other column of non-primary key column of base table.
A primary key of a Materialized View must contain all columns from the primary key of the base table.




Tokens:
=======
Cassandra assigns token to each nodes in the cluster to strorew the data.
Based on replication factor the data will store as many times it needs to 
