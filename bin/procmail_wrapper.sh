#!/bin/sh


[ `uname` = "SunOS" ] && exec /home/cbadescu/bin/procmail.sun /home/cbadescu/.procmailrc_dummy
[ `uname` = "Linux" ] && exec /usr/bin/procmail /home/cbadescu/.procmailrc_dummy
[ `uname` = "FreeBSD" ] && exec /usr/local/bin/procmail $@

echo "Should not get here" 
