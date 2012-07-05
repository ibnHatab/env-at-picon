#!/bin/sh

u=$2
shift
shift
echo $u
ssh $u ls

# arm-none-linux-gnueabi-gdb --annotate=3 -fullname $*
