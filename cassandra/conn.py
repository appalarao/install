from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider

auth_provider = PlainTextAuthProvider(username='srihari', password='123456')
cluster = Cluster(['10.142.0.4,10.142.0.5'],auth_provider = auth_provider)

keyspace='bheri'
conn=cluster.connect(keyspace)

query=conn.execute('select * from student')

for i in query:
	print "id %d and name is %s " %(i.id,i.name)
