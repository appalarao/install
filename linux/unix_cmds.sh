df -h  		#for disk size
du -sh *	#file size in current directory
free -m 	#memory in MB
free -gh	#memory in GB
top / w 	#load
top +1 		#to know cpu cores


compgen -u  	#list of users on machine
userdel postgres


Soft link
---------
ln -s /mylocation/tokeep/data data  #original file located at /mylocation/tokeep/data





Searching:
#########

	1. find 		#searches the file system when a file search is initiated
	2. locate(preferable)	# would look through a database mlocate (contains bits and parts of files and their corresponding paths on your system.)

locate:
#######

yum install mlocate

locate pg_hba.conf
locate -i *text.txt*  #case in-sensitive search
locate "*.conf" -n 20

locate -S #review local database.
#o/p:
Database /var/lib/mlocate/mlocate.db:
	39,279 directories
	4,92,385 files
	3,47,56,827 bytes in file names
	1,44,42,386 bytes used to store database

sudo updatedb # refreshes mlocate (seach db)

find:
#####
find . -name bheri.txt #Find bheri.txt in a current working directory.

find /home -name bheri.txt #Find bheri.txt in a /home directory.

find /home -iname bheri.txt #case in-sensitive search of bheri.txt in /home directory.

find /home/srihari/Desktop -type d -name bheri_new #find all directories whose name is bheri_new in Desktop direcotry

find /home/srihari/Desktop -type f -name "*.php"   # find all php files in Desktop directory

find . -type f -perm 0777 -print  #find files with 777 permissions

find . -type f ! -perm 0777 -print  #find files with out 777 permissions

find / -mtime 50 		#finds last 50days modified files






netstat -plnt   #ports

service --status-all | more/less

service --status-all | grep httpd

systemctl list-unit-files(Ubuntu+reh-hat family)

service postgresql-9.6 status/stop/running

installed:
----------
rpm -qa | grep 'postgresql'

available for installing:
-------------------------
yum list postgresql-plpython* 




===================================================

telent on cent os -7


yum install telnet telnet-server -y

systemctl start telnet.socket
systemctl enable telnet.socket

firewall-cmd --permanent --add-port=23/tcp
firewall-cmd --reload



change user acoount passwd:
su -
passwd user_name

os-version
cat /etc/os-release













Encryption:
===========

yum install ccrypt

ccrypt filename

crypt -d filename





