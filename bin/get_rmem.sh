
MODEM=135.221.57.54
#DIR=`mktemp -u -p . --tmpdir=rmem`
SUFIX=`date +%Y-%m-%d-%H-%M`
DIR="rmem/rmem-$SUFIX"

scp -r root@$MODEM:/tmp/root/0/rmem $DIR

echo -e "Copy RMEM from $MODEM into: $DIR"

