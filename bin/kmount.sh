#!/bin/sh

# add following line to fstab
#/dev/mapper/kingstone1G /mnt/kingstone1G    ext3 user,noauto     0       0

sudo cryptsetup luksOpen /dev/sdb1 kingstone1G 
mount /mnt/kingstone1G
cd /mnt/kingstone1G
