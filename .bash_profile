
if [ -e ~/.bashrc ]
then
    . ~/.bashrc
fi

#  HOME
PATH=$HOME/bin:/sbin::$PATH

#PYTHON
export PYTHONPATH=$HOME/libs:$PYTHONPATH
export MIBDIRS=+/usr/local/share/snmp/mibs/

#ALL_PROXY="http://cache.tm.alcatel.ro:8080"
#export http_proxy=$ALL_PROXY
#export HTTP_PROXY=$ALL_PROXY
#export ftp_proxy=$ALL_PROXY
#export FTP_PROXY=$ALL_PROXY

export XEDITOR='emacsclient --no-wait'

BLOCKSIZE=K;    export BLOCKSIZE
EDITOR=vim;     export EDITOR

ulimit -c 100000

HISTFILESIZE=1000000000
HISTSIZE=1000000
export HISTFILESIZE HISTSIZE

#Erlang
ERL_LIBS=/udir/tools/otp/lib/erlang/lib
ERL_LIBS=$ERL_LIBS:$HOME/libs/femto_test/deps:$HOME/libs/femto_test/apps
export ERL_LIBS

CC=`which cleartool 2>/dev/null`
if [ -n "${CC}" ]; then
#FACS setup
    [ -f /home/fbsrteam/bin/facs_setup ] && . /home/fbsrteam/bin/facs_setup && echo sourcing facs setup

fi


#RTDS_HOME=/opt/swe/tools/ext/pragmadev/rtds-4.03/i686-linux2.6
RTDS_HOME=/opt/swe/tools/ext/pragmadev/rtds-3.2b6/i686-linux2.4/
PATH=$PATH:/opt/rational/clearcase/bin/:/opt/exp/bin/:${RTDS_HOME}/bin:/opt/swe/tools/ext/rational/PurifyPlus-7.0.1.0_000_O/i686-linux2.6/bin/:/opt/swe/tools/ext/rational/purecov-7.0.1/purecov.i386_linux2.7.0/:/opt/swe/tools/ext/rational/quantify-7.0.1/quantify.i386_linux2.7.0:/opt/swe/tools/in/nmake-3.9/i686-linux2.6/bin/

LM_LICENSE_FILE=/home/cbadescu/public_html/license.dat:/home/cbadescu/public_html/license.rtds.dat:5555@135.86.206.75:/home/cbadescu/public_html/license.rvds.dat
export PATH RTDS_HOME LM_LICENSE_FILE


MANPATH=$MANPATH:/usr/kerberos/man:/usr/local/man:/usr/local/share/man:/usr/bin/man:/usr/share/doc/PyXML-0.8.4/man:/usr/share/man:/usr/share/locale/man

export MANPATH


PLTF_VOB_DELIVERY=/vobs/onepltf_ltefdd/delivery/

export PLTF_VOB_DELIVERY

umask 002
