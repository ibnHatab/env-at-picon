#!/usr/bin/expect


spawn /home/vlad/bin/connect_vpn.sh
expect "do you accept this (y to accept) :"
send "y\r"
expect "Enter username for"
send "vkinzers\r"
interact

