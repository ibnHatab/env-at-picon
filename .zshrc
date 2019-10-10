# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="af-magic"
ZSH_THEME="kiwi"
ZSH_THEME="apple"
#ZSH_THEME="awesomepanda"
ZSH_THEME="robbyrussell"

HYPHEN_INSENSITIVE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(zsh-autosuggestions fzf-zsh git battery dircycle rebar sbt docker cargo pip)

# User configuration


source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export ARCHFLAGS="-arch x86_64"
export SSH_KEY_PATH="~/.ssh/dsa_id"

# History
export HISTSIZE=5000000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history
#unsetopt bang_hist
setopt   hist_ignore_space
setopt   extended_history
setopt   hist_find_no_dups
setopt   inc_append_history
setopt   share_history
setopt   histignoredups

# word/by/word/break
export WORDCHARS='*?_-[]~&;=!#$%^(){}<>'
export WORDCHARS='*?-[]~&;!#$%^(){}<>'

# for laziness
alias     al='alias'                # alias-alias
alias       e='ec'
alias       f='find '
alias       o='open '
alias     nd='mkdir `date -I` && cd `date -I`'
alias     ng='noglob '              # shorter noglob command
alias   open='xdg-open'             # remember the command name
alias  rwget='noglob wget -nc -p --no-parent -r -l0'
alias      t='date +"%H.%M"'        # time in HH.MM format
alias  unzip='noglob unzip'         # don't use globs with unzip
alias    utf='file apps/*/src/*erl apps/*/include/*hrl Makefile | grep "UTF"'
alias   word='sed `perl -e "print int rand(99999)"`"q;d" /usr/share/dict/words'
alias     pd='pushd'
alias     po='popd'

alias     grep='grep --colour=tty --binary-files=text'
alias        h='fc -l -25'
alias    kdiff='kdiff3'
alias       ls='ls --color=tty '
alias        l='ls -CF --color=tty -rt'
alias       l.='ls .[a-zA-Z]* --color=tty -d'
alias       ll='ls -l --color=tty '
alias      ltr='ls -ltr --color=tty '
alias       pu='ps -fu $USER'
alias   sqlite='rlwrap sqlite3'
#alias      pwd="pwd | xclip -selection c"
#alias      cwd="cd `xclip -selection c -o`"

# speling | dyslexia
alias -g    vi='vim'
alias -g     c='cat'

alias       ping="grc ping"
alias traceroute="grc traceroute"
alias       diff="grc diff"
alias    netstat="grc netstat"

# TAPS:
# common pipe­ending commands (taps)
alias -g  A='|head'           # head (also A<n> were <n> is 1-30)
alias -g  B='|grep -v "^[       ]*$"' # kill blank rows
alias -g  C='|sort -f|uniq -c' # unique w/ counter (C0=no pre­sort)
alias -g C0='|uniq -c'        #
# D
alias -g  E='|perl -ne'       # as F, w/o implied print (E0 slurps)
alias -g E0='|perl -0777ne'   #
alias -g  F='|perl -pe'       # filter (perl, F0 slurps)
alias -g F0='|perl -0777pe'   #
alias -g  G='|egrep -i'       # (e)grep (G0 searches stderr too)
alias -g Gv='|egrep -iv'      # (e)grep (G0 searches stderr too)
alias -g G0='|&egrep -i'      #
# H
alias -g  I='|column'         # columnify (think: `I' is a column)
# J
alias -g  K='**/*rl(.)'       # note: not a tap
alias -g  L='|wc -l'          # line count
alias -g  M='|&less'          # more (M0 ingnores STDERR)
alias -g M0='|less'           #
# N  O  P  Q
alias -g  P='**/*py(.)'       # note: not a tap
alias -g  R='|unhtml'         # remove HTML (R0 removes man codes)
alias -g R0='|perl -pe "s/.[\b]//g"' # remove man page ^H codes
alias -g RL='apps/**/*rl(.)'  # note: not a tap
alias -g  S='|sort -f'        # alphabetic sort (S0 for numeric)
alias -g S0='|sort -n'        #
alias -g  T='|iconv -flatin1 -tutf-8' # latin1 to utf-8
alias -g TT='|iconv -futf-8 -tlatin1' # utf-8 to latin1
alias -g  U='|sort |uniq'     # unique (U0=no pre­sort)
alias -g U0='|uniq'           #
# V W
alias -g  X='|tr -s " " "\t" |cut -f' # cut on tabs and spaces
#alias -g  Y='|tee /tmp/tee_output.txt'
alias -g  Y='&>/dev/null &; disown' # fork process (`Y' is a fork)
alias -g  Z='|tail'           # tail (also Z<n> were <n> is 1-30)

alias -s txt='less -rE'
# clean escape's
alias stresc='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias d='docker'
alias dps='docker ps -a --format "{{.ID}}:\t{{.Status}}\t{{.Names}}"'
alias dc=docker-compose
alias wrf="wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Webex/Record\ Playback/AtAuthor.exe -PLAYER"

# aliases A<n> and Z<n> (where <n> is 1-30)
for ((i=1; i<=30; i++)); do     #
    alias -g A$i="|grc head -n$i"   # head (1-30 rows)
    alias -g Z$i="|grc tail -n$i"   # tail (1-30 rows)
done                            #
unset i                         #

# builtin functions
autoload -U zargs    ## zargs **/*~ -- rm
autoload -U zmv      ## zmv '(**/)(*) - (*) - (*) - (*).ogg' '$1/$2/$2 - $3/$2 - $3 - $4 - $5.ogg'
autoload -U run-help ## key sequence: ALT-h (aka ESC-h).
## cd foo [TAB]

source /usr/share/autojump/autojump.zsh
unalias gg > /dev/null  2>&1
function gg() { git grep -in "$@"; }

# keys
bindkey -s '^[l' "ls -CF --color=tty\n"

limit coredumpsize 0

export GZIP='-9'
export ZIPOPT='-9'
export VISUAL='vim'
export EDITOR='vim'



echo '-------------------------------------------'
 /usr/games/fortune -s
echo '-------------------------------------------'
echo

weather(){ curl -s "wttr.in/$1?m2"}

# TAS dev environment


#export PYTHONPATH=$PYTHONPATH:/home/axadmin/repo/tas/test/py/libs
#export PATH=$PATH:~/repo/misc-utils
#source ~/repo/tas/sdk/env*
#source ~/repo/bts-utils/env.sh

export JAVA_HOME=/usr/lib/jvm/java-8-oracle  
export JAVA_FLAGS='-Dhttp.proxyHost=135.245.192.7 -Dhttp.proxyPort=8000 -Dhttps.proxyHost=135.245.192.7 -Dhttps.proxyPort=8000' # ' -Dhttp.proxyUser=vkinzers  -Dhttp.proxyPassword=zaq1!QAZ'
export JAVA_FLAGS='-Dhttp.proxyHost=87.254.212.120 -Dhttp.proxyPort=8080 -Dhttps.proxyHost=87.254.212.120 -Dhttps.proxyPort=8080' # ' -Dhttp.proxyUser=vkinzers  -Dhttp.proxyPassword=zaq1!QAZ'
export _JAVA_OPTIONS=$JAVA_FLAGS
export SBT_HOME=/usr/share/sbt-launcher-packaging/bin/sbt-launch.jar  
export JAVA_OPTS=$JAVA_FLAGS
export SBT_OPTS=$JAVA_FLAGS
export SPARK_HOME=/usr/lib/spark  
export PATH=$PATH:$JAVA_HOME/bin  
export PATH=$PATH:$SBT_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin

#export CQLSH_NO_BUNDLED=true
#export PATH=~/.ccm/repository/3.6/bin/:$PATH


#source <(kubectl completion zsh)
#alias k=kubectl


