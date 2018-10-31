Memory architecture in PostgreSQL can be classified into two broad categories:
--------------------------------------------------------------------------
	Local memory area – allocated by each backend process for its own use(every connection).
	Shared memory area – used by all processes of a PostgreSQL server.


Local Memory Area:
-----------------
Each backend process allocates a local memory area for query processing; 
each area is divided into several sub-areas – whose sizes are either fixed or variable. 


work_mem:
=========
	Executor uses this area for sorting tuples by ORDER BY and DISTINCT operations, and for joining tables by merge-join and hash-join operations.

maintenance_work_mem:
====================
		Some kinds of maintenance operations (e.g., VACUUM, REINDEX) use this area.

temp_buffers:
============
		Executor uses this area for storing temporary tables.



Shared Memory Area:
------------------
A shared memory area is allocated by a PostgreSQL server when it starts up. This area is also divided into several fix sized sub-areas.


shared buffer pool:
==================
	PostgreSQL loads pages within tables and indexes from a persistent storage to here, and operates them directly.

WAL buffer:
==========
To ensure that no data has been lost by server failures, PostgreSQL supports the WAL mechanism. 
WAL data (also referred to as XLOG records) are transaction log in PostgreSQL; and WAL buffer is a buffering area of the WAL data before writing to a persistent storage.

commit log:
==========
	Commit Log(CLOG) keeps the states of all transactions (e.g., in_progress,committed,aborted) for Concurrency Control (CC) mechanism.

In addition to them, PostgreSQL allocates several areas as shown below:

Sub-areas for the various access control mechanisms. (e.g., semaphores, lightweight locks, shared and exclusive locks, etc)
Sub-areas for the various background processes, such as checkpointer and autovacuum.
Sub-areas for transaction processing such as save-point and two-phase-commit.

