#!/bin/bash

WID=`xwininfo -root -children | grep google-chrome | grep -v '"Google Chrome":' | head -1 | awk '{print $1}'`

xdotool  key --window $WID Ctrl+Tab

exit 0
