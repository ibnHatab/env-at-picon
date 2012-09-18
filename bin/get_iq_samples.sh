
SUFIX=`date +%Y-%m-%d-%H-%M`
SIZE=30720000
MODEM=135.221.57.54

set -x

echo -ne "IQ samples collection $SUFIX"

ssh root@$MODEM "/usr/bin/rdmem r 0x48000020 $SIZE -o /armcb/oam/etc/apilog/dl_iq.bin"
ssh root@$MODEM "/usr/bin/rdmem r 0x4ba98040 $SIZE -o /armcb/oam/etc/apilog/ul_iq.bin"

echo -ne "Convert IQ 11 into: iq-$SUFIX.txt"

wine start  /W ./conv_IQ.exe 11 dl_iq.bin ul_iq.bin iq-$SUFIX.txt
