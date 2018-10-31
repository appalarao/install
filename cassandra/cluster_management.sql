Removing nodes from Cassandra cluster:
--------------------------------------
nodetool removenode 940ba0cf-b75a-448c-a15e-40e05efbeb34 -- if the node is dead

nodetool removenode status


If a node is not down and we want to decommission it, then we use the nodetool decommission 
command to assign the data ranges that this node was responsible for to the remaining nodes in the cluster.




Adding nodes from Cassandra cluster:
--------------------------------------
check following fields in the new node:

auto_bootstrap: --Set this configuration option to true so that a newly joining node can collect data from other nodes.

listen_address: --Set this to the appropriate IP address of the node.

endpoint_snitch: --Ensure that the new node is using the same snitch as that being used by the other nodes.

seed_provider: --This lists the nodes that are in the seed node list in the existing cluster. Since this new node is bootstrapping, it can not be in the seed node list right now.

cluster_name: --Ensure that the cluster name is the same as that of the other nodes in the cluster.

In the Cassandra-rackdc.properties file, update the correct datacentre and rack information for the new node. 

After ensuring that all configurations are good, start Cassandra on this new node. 

--nodetool cleanup 

Once the new node is up and running, execute the nodetool cleanup 
command on all nodes other than this new node to clean up the partition keys that those nodes are no longer handling.
