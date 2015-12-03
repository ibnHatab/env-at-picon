#!/bin/bash
#
# L Nix <lornix@lornix.com>
# reload browser window
#
# whether to use SHIFT+CTRL+R to force reload without cache
RELOAD_KEYS="CTRL+R"
#RELOAD_KEYS="SHIFT+CTRL+R"
#
# set to whatever's given as argument
#
# get which window is active right now
MYWINDOW=$(xdotool getwindowfocus)
#
BROWSER=`xdotool search --onlyvisible --name "$1" | head -1`
xdotool windowfocus --sync ${BROWSER}
xdotool key --window ${BROWSER} 'F5'

# bring up the browser
### xdotool search --onlyvisible --name "$1" windowfocus key 'ctrl+r'
#
# sometimes the focus doesn't work, so follow up with activate
xdotool windowfocus --sync ${MYWINDOW}
