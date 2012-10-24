# .zshrc

# Set up the prompt

autoload -Uz promptinit
promptinit
#prompt walters
prompt adam2

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

unsetopt bang_hist
setopt   hist_ignore_space
setopt   extended_history
setopt   hist_find_no_dups
setopt   inc_append_history
setopt   share_history

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

autoload -U compinit
compinit -u

# Completion control
# don't include current dir in completions involving `..'
zstyle ':completion:*' ignore-parents parent pwd ..
# case insensetive file name completion
# zstyle ':completion:*' matcher-list '' \
#     'm:{a-zåäöA-ZÅÄÖ}={A-ZÅÄÖa-zåäö}' \
#     'r:|[._-]=** r:|=**'

# allow completion for `..'
zstyle ':completion:*' special-dirs ..

# from: ~/usr/tmp/zsh-completion/zsh-completion-intro.html
# (an introduction to zsh completion from www.linux-mag.com)
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# word/by/word/break
export WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

# for laziness
alias     al='alias'                # alias-alias                  [2003-12-11]
alias       d='date -I'
alias       e='ec'
alias     nd='mkdir `date -I` && cd `date -I`'
alias     ng='noglob '              # shorter noglob command       [2001­08­16]
alias   open='xdg-open'             # remember the command name    [2012-08-09]
alias     po='popd'
alias    psu='ps -u$USER'           # all my processes             [2003-12-16]
alias     pu='pushd'
alias  rwget='noglob wget -nc -p --no-parent -r -l0'
alias      t='date +"%H.%M"'        # time in HH.MM format         [2001­07­05]
alias  unzip='noglob unzip'         # don't use globs with unzip   [2001­10­16]
alias    utf='file apps/*/src/*erl apps/*/include/*hrl Makefile | grep "UTF"'
alias   word='sed `perl -e "print int rand(99999)"`"q;d" /usr/share/dict/words'
alias     pu='pushd'
alias     po='popd'

alias     grep='grep --colour=tty --binary-files=text'
alias        h='history 25'
alias    kdiff='kdiff3'
alias       ls='ls --color=tty '
alias        l='ls -CF --color=tty '
alias       l.='ls .[a-zA-Z]* --color=tty -d'
alias       ll='ls -l --color=tty '
alias      ltr='ls -ltr --color=tty '
alias       pu='ps -fu $USER'

# speling
alias       vi='vim'
alias       gti='git'



# alias expand after these commands
alias      noglob='noglob '         #                              [2003­06­14]
alias        sudo='sudo '           #                              [2003-04-23]
alias       watch='watch '          #                              [2003-06-14]

# for safety (make backups if destination already exists)
if [[ ! $(uname) == Darwin ]]; then
    alias -g    cp='cp -b'          # back up                      [2002­01­16]
    alias -g    ln='ln -b'          # back up                      [2001­01­16]
    alias       mv='mv -b'          # back up                      [2002­01­16]
fi

typeset -A account                             # "account" associative array
account=(
    caprica       vkinzers@caprica.mrc.alcatel.ro
    leonis        vkinzers@leonis.mrc.alcatel.ro
    mrclte80      vkinzers@mrclte80.mrc.alcatel.ro
    mrclte186     vkinzers@mrclte186.mrc.alcatel.ro
    panda         root@192.168.10.120
    earth         vkinzers@135.86.200.84
    test3         axadmin@135.243.22.28
    picon         135.247.145.123
)

# create ssh aliases
for k (${(k)account}) {                         # for each key in account
    alias $k="ssh $account[$k]"                 #   create an ssh alias
    alias ${k}xterm="$k -f 'xterm -T $k -n $k'" #   and an xterm alias
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
alias -g  G='|egrep'          # (e)grep (G0 searches stderr too)   [2002­08­15]
alias -g G0='|&egrep'         #                                    [2002­09­11]
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

#dyslexia
alias -g gti=git
alias -g umlet="/udir/tools/Umlet/umlet.sh"

# archives
alias -s txt='less -rE'

# aliases A<n> and Z<n> (where <n> is 1-30)
for ((i=1; i<=30; i++)); do     #
    alias -g A$i="|head -n$i"   # head (1-30 rows)                 [2002­05­20]
    alias -g Z$i="|tail -n$i"   # tail (1-30 rows)                 [2002­05­20]
done                            #
unset i                         #

# ~ places
hash -d repo=/local/vlad/repos/

# builtin functions
autoload -U zargs    ## zargs **/*~ -- rm
autoload -U zmv      ## zmv '(**/)(*) - (*) - (*) - (*).ogg' '$1/$2/$2 - $3/$2 - $3 - $4 - $5.ogg'
autoload -U run-help ## key sequence: ALT-h (aka ESC-h).
                     ## cd foo [TAB]
