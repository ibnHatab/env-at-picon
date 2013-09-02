#!/bin/sh
Xnest :1 -name "Bla"  -ac -geometry 1920x1080 &
export DISPLAY=:1
xsetroot -display :1 -solid black &
exec icewm 
