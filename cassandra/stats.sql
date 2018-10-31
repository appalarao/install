nodetool cfhistograms bheri student  --get sts of table
nodetool compactionstats --get comtaction details
nodetool cfstats bheri.student --stats about tables
nodetool cleanup / bheri /bheri student --

nodetool snapshot /bheri -- creates snpashot of a keyspaces
nodetool clearsnapshot /bheri --deletes all created snapshots

nodetool listsnapshots

nodetool compact bheri student --Forces a major compaction on one or more tables.

nodetool compactionhistory 

nodetool describecluster

nodetool describering bheri  --Provides the partition ranges of a keyspace.


nodetool disableautocompaction bheri student

nodetool enableautocompaction bheri student --Enables autocompaction for a keyspace and one or more tables.


**
nodetool statusbackup

nodetool disablebackup  --disables incremental backup

nodetool enablebackup

nodetool disablebinary  -- disables native transport.

nodetool enablebinary

nodetool disablegossip  --disables gossip protocol

nodetool enablegossip

nodetool disablehandoff  --Disables storing of future hints on the current node.

nodetool enablehandoff

nodetool pausehandoff --Pauses the hints delivery process.

nodetool resumehandoff


cqlsh protocaol(thrift)
-----------------
nodetool statusthrift

nodetool disablethrift   --disables thriftserver

nodetool enablethrift


nodetool drain  --Drains the node.


nodetool flush bheri student --Flushes tables from the memtable to disk(ie, memtables-->ss tables).

nodetool gcstats --garbage collection (GC) statistics.



nodetool getcompactionthreshold --Provides the min/max compaction thresholds in MB for a table.



nodetool getcompactionthroughput --Print the throughput (in MB/s) for compaction in the system.


nodetool getlogginglevels --Get the runtime logging levels.

nodetool getsstables bheri student partition-key --Provides the SSTables that own the partition key.

nodetool getstreamthroughput -- throughput limit(MB/s) for outbound streaming in the system.

nodetool gossipinfo  


nodetool info


nodetool invalidatekeycache  --Resets the global key cache parameter(key_cache_keys_to_save) to the default, which saves all keys.

nodetool invalidaterowcache  --Resets the global key cache parameter, row_cache_keys_to_save, to the default (not set), which saves all keys.

nodetool join  --Causes the node to join the ring.

nodetool netstats

nodetool proxyhistograms

nodetool rangekeysample  --Provides the sampled keys held across all keyspaces.

nodetool rebuild_index  bheri student index_name

create index name(optional) on bheri.student(name);

nodetool refresh /bheri student --Loads newly placed SSTables onto the system without a restart.
			--used when get ss tables from another nodes manually(snapshot)

nodetool reloadtriggers --Reloads trigger classes.

nodetool repair bheri student

nodetool ring  --outputs all the tokens of a node

nodetool scrub   --Creates a snapshot and then rebuilds SSTables on a node.




nodetool statusbinary  --Provide the status of native transport.

nodetool statusgossip
nodetool statushandoff



nodetool stop --Stops the compaction process.

nodetool stopdaemon  --Stops the cassandra daemon.

nodetool toppartitions --prints the most active partitions during the duration specified. A keyspace and column family must be specified, as well as a duration in milliseconds.

nodetool toppartitions bheri student 1000

nodetool tpstats    --Provides usage statistics of thread pools.

nodetool truncatehints  --Truncates all hints on the local node/endpoints(other nodes in the cluser).


nodetool upgradesstables  --Rewrites older SSTables to the current version of Cassandra.

upgradesstables -a keyspace table

nodetool version

nodetool removenode node-host-id
