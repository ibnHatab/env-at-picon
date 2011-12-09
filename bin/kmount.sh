#!/bin/sh

sudo cryptsetup luksOpen /dev/sdb1 kingstone1G 
sudo mount /dev/mapper/kingstone1G /mnt/kingstone1G
