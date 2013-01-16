
if [ -e ~/.bashrc ]
then
    . ~/.bashrc
fi

#  HOME
PATH=$HOME/bin:/sbin::$PATH

#PYTHON
export PYTHONPATH=$HOME/libs:$PYTHONPATH
export MIBDIRS=+/usr/local/share/snmp/mibs/

ALL_PROXY="http://cache.tm.alcatel.ro:8080"
export http_proxy=$ALL_PROXY
export HTTP_PROXY=$ALL_PROXY
export ftp_proxy=$ALL_PROXY
export FTP_PROXY=$ALL_PROXY

export XEDITOR='emacsclient --no-wait'

BLOCKSIZE=K;    export BLOCKSIZE
EDITOR=vim;     export EDITOR

ulimit -c 100000

HISTFILESIZE=1000000000
HISTSIZE=1000000


#Erlang
export ERL_LIBS=/usr/lib/erlang/lib:$HOME/libs/femto_test/deps:$HOME/libs:/local/$USER/repos/superdeps/
