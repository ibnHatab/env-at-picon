xrandr --output LVDS1 --off 
xrandr --output DP3 --auto --rotate normal --pos 0x0 --output VGA1 --auto --rotate normal --right-of DP3

#if [ -x /usr/bin/nm-applet ] ; then
#   nm-applet --sm-disable &
#fi

#gnome-power-manager > /dev/null &
#sudo cpufreq-set --cpu 1 --governor ondemand
#sudo cpufreq-set --cpu 0 --governor ondemand

gnome-settings-daemon > /dev/null &

xrdb $HOME/.Xdefaults
xset -b
xhost +
xset r 130
xset r 103


#xsetroot -solid midnightblue
#xsetroot -cursor_name left_ptr

#xscreensaver -no-splash &

setxkbmap -layout us,ru\(phonetic\) -option "grp:rwin_toggle,grp_led:scroll"

xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add Control = Control_L"


#gnome-terminal &
#gnome-session
#exec i3 
exec xmonad
