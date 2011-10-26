#!/bin/bash

SELECT_WINDOW=0
if [ "x$1" != "x" ]; then
    SELECT_WINDOW=$1
fi

DEVEL_DIR=$HOME/devel
SCREEN_OPTS="-h 10000 -e^Zz -U"

function screen_list() {
    screen -list | grep Multi | awk '{print $1}' | sed 's/.*\.//'
}

function port_number() {
    grep $PROJECT /etc/services | awk '{print $2}' | sed 's/\/.*//'
}

OLD_PS3=$PS3

PS3="Which screen session to restore? "
select PROJECT in `screen_list` New; do
    if [ $PROJECT == "New" ]; then
        PS3="Which project to start a session for? "
        select PROJECT in `ls -F $DEVEL_DIR | egrep /$ | sed 's/\///' `; do
        PS3=$OLD_PS3
        screens=`screen_list | grep $PROJECT`
        if [ "x$screens" == "x" ]; then

            screen -d -m $SCREEN_OPTS -S $PROJECT

            screen -X -S $PROJECT -p 0 title emacs 
            screen -X -S $PROJECT -p 0 stuff "emacs $DEVEL_DIR/$PROJECT
"
            screen -X -S $PROJECT screen -t test 1
            screen -X -S $PROJECT -p 1 stuff "cd $DEVEL_DIR/$PROJECT; autotest
"
            screen -X -S $PROJECT screen -t server 2
            PORT=`port_number`
            screen -X -S $PROJECT -p 2 stuff "cd $DEVEL_DIR/$PROJECT; ./script/server -p $PORT
"
            screen -X -S $PROJECT screen -t console 3
            screen -X -S $PROJECT -p 3 stuff "cd $DEVEL_DIR/$PROJECT; ./script/console
"
            screen -X -S $PROJECT screen -t bash 4
            screen -X -S $PROJECT -p 4 stuff "cd $DEVEL_DIR/$PROJECT
"

            for i in 0 1 2 3
            do
                # do this to force screen to refresh the hard status line
                screen -X -S $PROJECT select $i
            done
        fi
        screen -x $PROJECT -p $SELECT_WINDOW
        PS3="Which project to start a session for? "
        done
    fi
    screen -x $PROJECT -p $SELECT_WINDOW
    PS3="Which screen session to restore? "
done
PS3=$OLD_PS3
