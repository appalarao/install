login as root

STEP1:check all the packages available https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#BHCFACHG

yum list binutils-2.20.51.0.2-5.36.el6 (x86_64) 
compat-libcap1-1.10-1 (x86_64) 
compat-libstdc++-33-3.2.3-69.el6 (x86_64)  
gcc-4.4.7-4.el6 (x86_64) 
gcc-c++-4.4.7-4.el6 (x86_64) 
glibc-2.12-1.132.el6 (x86_64) 
glibc-devel-2.12-1.132.el6 (x86_64)   
libgcc-4.4.7-4.el6 (x86_64) 
libstdc++-4.4.7-4.el6 (x86_64)  
libstdc++-devel-4.4.7-4.el6 (x86_64) 
libaio-0.3.107-10.el6 (x86_64) 
libaio-devel-0.3.107-10.el6 (x86_64)  
sysstat-9.0.4-22.el6 (x86_64)

STEP 2:

create groups used for allocation to users:

/usr/sbin/groupadd -g 500 oinstall
/usr/sbin/groupadd -g 502 dba
/usr/sbin/groupadd -g 503 oper



/usr/sbin/groupadd -g 504 asmadmin
/usr/sbin/groupadd -g 506 asmdba
/usr/sbin/groupadd -g 505 asmoper

#set primary/secondsy users of groups
STEP 3:
/usr/sbin/usermod -g oinstall -G dba,oper oracle

STEP 4:

cd /

STEP 5: create /u01 with root credentials:

mkdir -p /opt1/oracle/oracle01
mkdir -p /opt1/oracle/oracle02
mkdir -p /opt1/oracle/oracle03
mkdir -p /opt1/oracle/oracle04
mkdir -p /opt1/oracle/oracle05
mkdir -p /opt1/oracle/oracle06
mkdir -p /opt1/oracle/oracle08
mkdir -p /opt1/oracle/oracle07



 ln -s /opt1/oracle/oracle01 u01
 ln -s /opt1/oracle/oracle02 u02
 ln -s /opt1/oracle/oracle03 u03
 ln -s /opt1/oracle/oracle04 u04
 ln -s /opt1/oracle/oracle05 u05
 ln -s /opt1/oracle/oracle06 u06
 ln -s /opt1/oracle/oracle08 u08
 ln -s /opt1/oracle/oracle07 u07




 mkdir -p /u01/app/

chown -R oracle:oinstall /u01/app/
chmod -R 775 /u01/app/


chown -R oracle:oinstall /opt1


STEP 5: Copy oracle_software in home location from any other server which consists of zip files.


STEP 6:

login to VNC viewer with format : <ipaddress>:5901

open new terminal

STEP 7:

a).check etc/sysctl.conf and /etc/security/limits.conf to fix maximum processes softlimit and ip_local_port_range 

b.) run root.sh script once the installation is finished.


STEP 8: create .bash_profile with oracle credentials

vim .bash_profile

PATH=$PATH:$HOME/bin
ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH:$HOME/bin
CLASSPATH=$ORACLE_HOME/jre:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/X11R6/lib:/lib:/usr/lib
umask 022
TEMP=/tmp
TMPDIR=/tmp
unset USERNAME
export EDITOR=vi

export PATH

STEP 9:

a).Create same directory structure.
i.e.mkdir -p /u01/app/oracle/admin/main/adump/   
mkdir -p /u01/app/oracle/flash_recovery_area/main
mkdir -p /u07/oradata/main/arch/
mkdir -p /u07/oradata/main/arch-bkp/


b).Copy initmain.ora file.
c).Copy datafiles, control files, redologfiles, tempfiles

d).Copy all sh and .ora files, backup_main_lzero.sh and all required files from Home/Oracle
     (Related to active sql, expensive_sql)
e). Copy control02.ctl inside flash_recovery_area 
/u01/app/oracle/flash_recovery_area/main/control02.ctl

f).  If you have archive files and wants to recover them , then copy all archive files.

STEP 10:

connect with sqlplus / as sysdba

a. Mount pfile from in itmain.ora
startup MOUNT PFILE='/home/oracle/init_main_12dec.ora'

b. run below command  to run recovery :-
recover database using backup controlfile until cancel;





#

cat /u01/app/oracle/product/11.2.0/dbhome_1/root.sh
