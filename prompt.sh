
# Set up the prompt
autoload -Uz promptinit
promptinit
#prompt walters
prompt adam2

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
zstyle ':completion:*' special-dirs ..
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
