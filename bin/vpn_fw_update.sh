#!/bin/sh

#allow loopback traffix
sudo iptables -t filter -D OUTPUT  3
sudo iptables -t filter -I OUTPUT 3 -o lo -j ACCEPT
sudo iptables -t filter -D INPUT  3
sudo iptables -t filter -I INPUT 3 -i lo -j ACCEPT

#allow local traffic while in VPN
#sudo iptables -t filter -I OUTPUT 4 -o wlan0 -d 192.168.201.0/24 -j ACCEPT
#sudo iptables -t filter -I INPUT 4 -i wlan0 -s 192.168.201.0/24 -j ACCEPT
sudo iptables -t filter -I OUTPUT 4 -o wlan0 -d 192.168.2.0/24 -j ACCEPT
sudo iptables -t filter -I INPUT 4 -i wlan0 -s 192.168.2.0/24 -j ACCEPT
sudo iptables -t filter -I OUTPUT 4 -o ppp0 -d 10.0.1.0/24 -j ACCEPT
sudo iptables -t filter -I INPUT 4 -i ppp0 -s 10.0.1.0/24 -j ACCEPT
#masquerade for palm on BT
sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

#keep rds VoIP on wlan
#sudo iptables -t filter -I OUTPUT 4 -o wlan0 -d registrar.digioriunde.rcs-rds.ro -j ACCEPT
#sudo iptables -t filter -I INPUT 4 -i wlan0 -s registrar.digioriunde.rcs-rds.ro -j ACCEPT
#sudo route add registrar.digioriunde.rcs-rds.ro gw 192.168.1.1

#vobx not needed in case of NAT port forwarding
#iptables -t filter -D OUTPUT  4
#iptables -t filter -I OUTPUT 4 -o vboxnet0 -j ACCEPT
#iptables -t filter -D INPUT  4
#iptables -t filter -I INPUT 4 -i vboxnet0 -j ACCEPT

