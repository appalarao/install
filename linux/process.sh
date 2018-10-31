in top , ni-->nice value and pr-->priority

-20(most priority proces)
+20(least priority proces)



PR = 20 + NI

PR=rt  #means the process is running under real time scheduling priority.

###process default priority value is 0

cat /proc/24475/stat | awk '{print "priority " $18 " nice " $19}'

#reset priority 
renice -n -5 -p 24475

#set priority to bash
nice -n -5 bash

#get postgres parent process
/usr/pgsql-10/bin/pg_ctl -D /pgdata/data/ status


child process of parent process
===============================
pgrep -P 37526

pgrep -P 24306 | wc -l


ps -ef |ppid 2

ps -p 2 -o comm=


#sleeping process

ps h -eo s,pid | awk '{ if ($1 == "S" || $1 == "D") { print $2 } }' | wc -l


#parent from child
grep ^PPid: /proc/12345/status

pgrep -P 2 | wc -l
##################################################################################################################################################

Init process has PID of one

0-->swapper process
1-->init process(super parent of all the processes in a Linux session)



#when a parent process gets killed while child is still alive?
Well in this case, the child obviously becomes orphan but is adopted by the init process.
 So, init process becomes the new parent of those child processes whose parents are terminated.

