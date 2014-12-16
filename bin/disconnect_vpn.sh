#!/bin/sh


sudo /usr/bin/vpnc-disconnect; sudo iptables -F; sudo rmmod iptable_filter
#sudo resolvconf -d tun0
#sudo /etc/init.d/dnsmasq restart
