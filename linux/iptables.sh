#block ip address
sudo iptables -A INPUT -s 15.15.15.51 -j DROP
A-->Add to chain
INPUT  -->input chain
-s -->source 
DROP-->action


#Allow all incoming ssh
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

-p protocol tcp/udp
--dport/sport  -->destinanation/source port
--ctstate--connection state
For output chain only established is sufficient

#specific subnet
sudo iptables -A INPUT -p tcp -s 15.15.15.0/24 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#allow all incoming http+https

sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Allow MySQL from Specific IP Address or Subnet

sudo iptables -A INPUT -p tcp -s 15.15.15.0/24 --dport 3306 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 3306 -m conntrack --ctstate ESTABLISHED -j ACCEPT


#PostgreSQL from Specific IP Address or Subnet

sudo iptables -A INPUT -p tcp -s 15.15.15.0/24 --dport 5432 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 5432 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Block Outgoing SMTP Mail

sudo iptables -A OUTPUT -p tcp --dport 25 -j REJECT



#save ip tables

sudo /sbin/iptables-save  #ubuntu

/sbin/service iptables save  (or) /etc/init.d/iptables save  #red-hat family

