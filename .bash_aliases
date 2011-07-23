
alias grep='grep --colour=tty --binary-files=text'
alias h='history 25'
alias js='jumpstat'
alias jumpstat='autojump --stat'
alias kdiff='kdiff3'
alias l='ls -CF --color=tty '
alias l.='ls .[a-zA-Z]* --color=tty -d'
alias la='ls -A --color=tty '
alias ll='ls -l --color=tty '
alias ltr='ls -ltr --color=tty '
alias pu=' ps -fu $USER'
alias t='. title'
alias tl='tail -1'
alias vi='vim'


#autojump
    _autojump()
    {
        local cur
            cur=${COMP_WORDS[*]:1}
            while read i
            do
        COMPREPLY=("${COMPREPLY[@]}" "${i}")
            done  < <(autojump --bash --completion $cur)
    }
    complete -F _autojump j
    AUTOJUMP='{ (autojump -a "$(pwd -P)"&)>/dev/null 2>>${HOME}/.autojump_errors;} 2>/dev/null'
    alias js=jumpstat

    if [[ ! $PROMPT_COMMAND =~ autojump ]]; then
        export PROMPT_COMMAND="${PROMPT_COMMAND:-:} && $AUTOJUMP"
    fi
    alias jumpstat="autojump --stat"
    function j { new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; cd "$new_path";fi }
