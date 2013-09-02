
ADDR=0x43200040
SIZE=$1
MODEM=135.221.57.54
FILE="/armcb/oam/etc/apilog/m_log_$SIZE.bin"
echo -e "Writing to: $FILE"

ssh root@$MODEM "/usr/bin/rdmem r $ADDR $SIZE -o $FILE"


