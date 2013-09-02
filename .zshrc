# .zshrc

# Path to your OH-MY-ZSH configuration.
ZSH=$HOME/.oh-my-zsh
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
ZSH_THEME="robbyrussell"
ZSH_THEME="funky"
ZSH_THEME="alanpeabody"
ZSH_THEME="af-magic"   

declare -A viewmap
viewmap["aeries"]="3den"
viewmap["caprica"]="afowler"
viewmap["tauron"]="robbyrussell"
viewmap["leonis"]="alanpeabody"
viewmap["marvel"]="af-magic"

ZSH_THEME="${viewmap["$HOST"]}"

#DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

# Example format: plugins=(debian git-flow compleat rails git textmate ruby lighthouse)
plugins=(git git-flow  dircycle rebar debian)

source $ZSH/oh-my-zsh.sh

#For alternative PROMPT 
#source env/prompt.sh

# completion
setopt   complete_in_word
setopt   list_packed
unsetopt list_types
setopt   mark_dirs

# globbing
unsetopt auto_menu
unsetopt auto_remove_slash
setopt   nomatch
setopt   numeric_glob_sort
setopt   extended_glob

# job processing
unsetopt check_jobs
unsetopt hup

# miscellaneous
setopt   auto_cd
unsetopt clobber
setopt   dvorak
unsetopt flow_control
setopt   interactive_comments

# correctio
unsetopt correct
unsetopt correctall


# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
bindkey ";5D" backward-word
bindkey ";5C" forward-word
bindkey ";3D" backward-word
bindkey ";3C" forward-word

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
alias     al='alias'                # alias-alias                  [2003-12-11]
alias       d='date -I'
alias       e='ec'
alias       o='open '
alias     nd='mkdir `date -I` && cd `date -I`'
alias     ng='noglob '              # shorter noglob command       [2001­08­16]
alias   open='xdg-open'             # remember the command name    [2012-08-09]
alias     po='popd'
alias    psu='ps -u$USER'           # all my processes             [2003-12-16]
alias  rwget='noglob wget -nc -p --no-parent -r -l0'
alias      t='date +"%H.%M"'        # time in HH.MM format         [2001­07­05]
alias  unzip='noglob unzip'         # don't use globs with unzip   [2001­10­16]
alias    utf='file apps/*/src/*erl apps/*/include/*hrl Makefile | grep "UTF"'
alias   word='sed `perl -e "print int rand(99999)"`"q;d" /usr/share/dict/words'
alias     pd='pushd'
alias     po='popd'

alias     grep='grep --colour=tty --binary-files=text'
alias        h='fc -l -25'
alias    kdiff='kdiff3'
alias       ls='ls --color=tty '
alias        l='ls -CF --color=tty '
alias       l.='ls .[a-zA-Z]* --color=tty -d'
alias       ll='ls -l --color=tty '
alias      ltr='ls -ltr --color=tty '
alias       pu='ps -fu $USER'

# speling | dyslexia
alias -g    vi='vim'
alias -g     c='cat'
alias -g   gti=git
alias -g umlet="/udir/tools/Umlet/umlet.sh"

# alias expand after these commands
alias      noglob='noglob '         #                              [2003­06­14]
alias        sudo='sudo'           #                              [2003-04-23]
alias       watch='watch '          #                              [2003-06-14]

alias       ping="grc ping"
alias traceroute="grc traceroute"
alias       diff="grc diff"
alias    netstat="grc netstat"

alias         st="/local/tools/Sublime_Text_2/sublime_text"

# create ssh aliases
typeset -A account                             # "account" associative array
account=(
    aeries        vkinzers@135.243.22.59
#    leonis        vkinzers@135.243.22.61
    leonis        vkinzers@135.243.2.148
    caprica       vkinzers@135.243.22.63
    tauron        vkinzers@135.243.22.64

    aquaria       vkinzers@135.247.153.150
	tomtom        root@135.247.153.151

    mrclte80      vkinzers@mrclte80.mrc.alcatel.ro
    mrclte182     vkinzers@mrclte182.mrc.alcatel.ro
    mrclte186     vkinzers@mrclte186.mrc.alcatel.ro

    earth         vkinzers@135.86.200.84
    iceccase3	  vkinzers@135.86.206.143
	MASVRSUN01    lte@135.86.200.121 # wayaround to ftp://alc-luc:naka5Eju@ftp.spg-tm.com
)
for k (${(k)account}) {                         # for each key in account
    alias $k="ssh -X $account[$k]"                 #   create an ssh alias
#    alias ${k}xterm="$k -f 'xterm -T $k -n $k'" #   and an xterm alias
}; unset k                                      #


# TAPS:
# common pipe­ending commands (taps)
alias -g  A='|head'           # head (also A<n> were <n> is 1-30)  [2001­10­20]
alias -g  B='|grep -v "^[       ]*$"' # kill blank rows            [2002­05­21]
alias -g  C='|sort -f|uniq -c' # unique w/ counter (C0=no pre­sort)[2002­08­15]
alias -g C0='|uniq -c'        #                                    [2002­05­21]
# D
alias -g  E='|perl -ne'       # as F, w/o implied print (E0 slurps)[2002­08­16]
alias -g E0='|perl -0777ne'   #                                    [2002­08­16]
alias -g  F='|perl -pe'       # filter (perl, F0 slurps)           [2002­01­10]
alias -g F0='|perl -0777pe'   #                                    [2002­08­16]
alias -g  G='|egrep -i'          # (e)grep (G0 searches stderr too)   [2002­08­15]
alias -g G0='|&egrep -i'         #                                    [2002­09­11]
# H
alias -g  I='|column'         # columnify (think: `I' is a column) [2002­05­21]
# J
alias -g  K='**/*rl(.)'       # note: not a tap                    [2010-06-16]
alias -g  L='|wc -l'          # line count                         [2007­03­27]
alias -g  M='|&less'          # more (M0 ingnores STDERR)          [2003­02­03]
alias -g M0='|less'           #                                    [2001­10­20]
# N  O  P  Q
alias -g  P='**/*py(.)'       # note: not a tap                    [2010-10-01]
alias -g  R='|unhtml'         # remove HTML (R0 removes man codes) [2002­08­17]
alias -g R0='|perl -pe "s/.[\b]//g"' # remove man page ^H codes    [2002­08­16]
alias -g RL='apps/**/*rl(.)'  # note: not a tap                    [2007-09-07]
alias -g  S='|sort -f'        # alphabetic sort (S0 for numeric)   [2002­01­10]
alias -g S0='|sort -n'        #                                    [2002­05­21]
alias -g  T='|iconv -flatin1 -tutf-8' # latin1 to utf-8            [2008-07-28]
alias -g TT='|iconv -futf-8 -tlatin1' # utf-8 to latin1            [2008-07-28]
alias -g  U='|sort |uniq'     # unique (U0=no pre­sort)            [2002­08­15]
alias -g U0='|uniq'           #                                    [2002­01­10]
# V W
alias -g  X='|tr -s " " "\t" |cut -f' # cut on tabs and spaces     [2002­04­27]
#alias -g  Y='|tee /tmp/tee_output.txt'
alias -g  Y='&>/dev/null &; disown' # fork process (`Y' is a fork) [2002­08­27]
alias -g  Z='|tail'           # tail (also Z<n> were <n> is 1-30)  [2001­10­20]

alias -s txt='less -rE'

# aliases A<n> and Z<n> (where <n> is 1-30)
for ((i=1; i<=30; i++)); do     #
    alias -g A$i="|grc head -n$i"   # head (1-30 rows)                 [2002­05­20]
    alias -g Z$i="|grc tail -n$i"   # tail (1-30 rows)                 [2002­05­20]
done                            #
unset i                         #

autoload -U compinit && compinit -u
# autojump
[[ -s ~/.autojump/etc/profile.d/autojump.zsh ]] && source ~/.autojump/etc/profile.d/autojump.zsh

# ~ places
hash -d repo=/local/vlad/repos/
hash -d store=/net/aeries/local/storage/
hash -d sc=/net/pluto/vol/vol3/timco/SmallCells


# builtin functions
autoload -U zargs    ## zargs **/*~ -- rm
autoload -U zmv      ## zmv '(**/)(*) - (*) - (*) - (*).ogg' '$1/$2/$2 - $3/$2 - $3 - $4 - $5.ogg'
autoload -U run-help ## key sequence: ALT-h (aka ESC-h).
                     ## cd foo [TAB]

function lt() { ls -ltrsa "$@" | tail; }
function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; }
function fname() { find . -iname "*$@*"; }
function remove_lines_from() { grep -F -x -v -f $2 $1; }
unalias gg
function gg() { git grep -in "$@"; }

#removes lines from $1 if they appear in $2
alias pp="ps axuf | pager"

# keys
bindkey -s '^[l' "ls -CF --color=tty\n"

setterm -blength 0

export JAVA_HOME=/local/tools/jdk1.7.0_21/
export SCALA_HOME=/local/tools/scala/scala
export GROOVY_HOME=/local/tools/scala/groovy
# Customize to your needs...
export PATH=$HOME/bin:/sbin:/usr/bin:/bin:/usr/local/bin:$GROOVY_HOME/bin:$SCALA_HOME/bin:/local/tools/scala/sbt/bin:$JAVA_HOME/bin

# Android
export ADT_HOME=/local/tools/scala/adt-bundle-linux-x86-20130522/sdk
export PATH=$PATH:$ADT_HOME/tools:$ADT_HOME/platform-tools

#CLANG
export PATH=$PATH:/local/tools/clang/bin:/local/tools/clang/share/scan-view
