#!/bin/sh

sudo umount /mnt/kingstone1G
sudo cryptsetup luksClose /dev/mapper/kingstone1G 
