#!/bin/sh

if [ -z $1 ]
then
        echo "First arg is screen name, rest is command to run"
fi
if [ ! -z $1 ]
then
        SCREEN_NAME=$1
        shift
        echo "Running commands ($*) under screen name $SCREEN_NAME"
        screen -S $SCREEN_NAME -X stuff "$* "
fi
