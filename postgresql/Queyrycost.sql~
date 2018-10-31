Sequential Scan:
===============
The cost of the sequential scan is estimated by the cost_seqscan() function.

In the sequential scan, the start-up cost is equal to 0, and the run cost is defined by the following equation:

	run_cost = cpu_run_cost+disk_run_cost
		 
		= (cpu_tuple_cost + cpu_operator_cost)×Ntuple + seq_page_cost×Npage

	run_cost=cpu_run_cost+disk_run_cost = (cpu_tuple_cost+cpu_operator_cost)×Ntuple+seq_page_cost×Npage



SELECT relpages, reltuples FROM pg_class WHERE relname = 'tbl';
 relpages | reltuples 
----------+-----------
       45 |     10000

	Ntuple=10000

	Npage=45

stored in postgresql.conf file:
-------------------------------
cpu_tuple_cost=0.01
cpu_operator_cost=0.0025
seq_page_cost=1

			run_cost =( 0.01+0.0025)×10000+1.0×45=170.0.

			total_cost=0.0+170.0=170

EXPLAIN SELECT * FROM tbl WHERE id < 8000;
                       QUERY PLAN                       
--------------------------------------------------------
 Seq Scan on tbl  (cost=0.00..170.00 rows=8000 width=8)

0.00-->starting_cost
170.00-->run_cost

total_cost=starting_cost+run_cost



Indexed Scan:
=============
Start-Up Cost
The start-up cost of the index scan is the cost to read the index pages to access to the first tuple in the target table, and it is defined by the following equation:

 start_up_cost ={ceil(log2(Nindex,tuple))+(Hindex+1)×50}×cpu_operator_cost,

where 
	Hindex is the height of the index tree.

create extension pgstattuple;
SELECT * FROM pgstatindex('pg_default_acl_oid_index');

 SELECT relpages, reltuples FROM pg_class WHERE relname = 'tbl_data_idx';
 relpages | reltuples 
----------+-----------
       30 |     10000



start-up cost={ceil(log2(10000))+(1+1)×50}×0.0025=0.285.
 
Run Cost:
========
	The run cost of the index scan is the sum of the cpu costs and the IO (input/output) costs of both the table and the index:

	run_cost=(index_cpu_cost+table_cpu_cost)+(index_I/O_cost+table_I/O_cost)


