Swap space is located on hard drives, which have a slower access time than physical memory.
Swap space in Linux is used when the amount of physical memory (RAM) is full.


#make swapness as 0
vi /etc/sysctl.conf

vm.swappiness=0

 sysctl -p


#restart swap mem / moves swap mem from swap to ram
swapoff -a;swapon -a
