Example:
ssh-keygen -t rsa -f ~/.ssh/my-ssh-key -C srihari

instance-1:
ssh -i ~/.ssh/my-ssh-key srihari@35.196.202.19




instance-1:
ssh srihari@35.229.36.95
10.142.0.2


instance-2:
ssh srihari@35.231.179.74
10.142.0.3

instance-3:
ssh srihari@35.190.176.106
10.142.0.4





/etc/cassandra/cassandra.yaml


service cassandra stop

rm -rf /var/lib/cassandra/data/system/*
=========================================================


sudo lsblk

#format disk /dev/sdc

sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb

sudo mkdir -p /opt1	#create mounting directory

#mount disk to the directory 
sudo mount -o discard,defaults /dev/sdb /opt1


sudo chmod a+w /opt1


======================================
new ips

ssh srihari@104.196.179.97  10.142.0.2

ssh srihari@35.231.57.203   10.142.0.3

ssh srihari@35.196.20.195   10.142.0.5

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

