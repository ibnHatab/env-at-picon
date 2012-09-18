
ADDR=0x40000020
SIZE=$1
MODEM=135.221.57.54
FILE="/armcb/oam/etc/apilog/api_log_$SIZE.bin"
echo -e "Writing to: $FILE"

ssh root@$MODEM "/usr/bin/rdmem r $ADDR $SIZE -o $FILE"


