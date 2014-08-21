# ~/.bashrc: executed by bash(1) for non-login shells.

[ -z "$PS1" ] && return

HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
HISTCONTROL=ignoreboth

shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi


CC=`which cleartool 2>/dev/null`

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h[\W$(__git_ps1 " (%s)")]\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]

if [ -z "${CC}" ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h[\W$(__git_ps1 " (%s)")]\[\033[00m\]: \[\033[01;32m\]\w\[\033[00m\]
$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h[$(cleartool pwv -s)]\[\033[00m\]: \[\033[01;32m\]\w\[\033[00m\]
$ '

fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h: \w
$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
##    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.clipboard ]; then
    . ~/.clipboard
fi

# Added by autojump install.sh
source ~/.autojump/etc/profile.d/autojump.bash

export OOO_FORCE_DESKTOP=gnome
#export LM_LICENSE_FILE=$HOME/libs/license.dat

export PATH=$PATH:/udir/tools/arm-2008q3/bin
export PATH=$PATH:/udir/tools/arm-linux-2008q3/bin

#Switch to ZSH if any
#if [ -f /usr/bin/zsh ]; then
#/usr/bin/zsh
#fi

