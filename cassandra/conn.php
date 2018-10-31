<?php
     $cluster = Cassandra::cluster()
                ->withContactPoints('173.231.179.142')
                ->withPort(9042)
                ->withCredentials("cassandra", "cassandra")
                ->withPersistentSessions(true)
                ->withDefaultConsistency(Cassandra::CONSISTENCY_LOCAL_ONE)
                ->withDatacenterAwareRoundRobinLoadBalancingPolicy("Cassandra", 0, false)
                ->build();
                $dbh = $cluster->connect('im_cass_mesh');  



if($dbh)
	print "\n===========success==========\n";
else
	print "\n===========fail==========\n";
exit;
			$query = "select * from glusr_factsheet_details limit 5";
			$options   = array('page_size' => 5000);
			
			echo $query;

			$rows = $cass->execute(new Cassandra\SimpleStatement($query), $options);

			$count = 0;
			$count1 = 0;
			while(true)
			{

				foreach($rows as $gldata) 
				{
					$count++;

					if( $gldata['glusr_fs_table_name'] == "TRUSTSEAL" && $gldata['glusr_fs_attribute'] == "TRUSTSEAL_ID" )
					{
						echo "\nCount: " . $count1 . " GLID: " . $gldata['glusr_fs_usr_id'];
						$count1++;

					}
				}

				if($rows->isLastPage())
				{
					break;
				}

				$rows = $rows->nextPage();
			}

			echo "\ncount: " . $count;
			echo "\ncount1: " . $count1;
			echo "\ndel_count: " . $this->del_count;
			echo "\ninsert_count: " . $this->insert_count;


?>
