TERM="xterm-256color"
EDITOR="nano"

alias ls='ls --color=always --time-style="+%Y-%m-%d %H:%M"'
alias ll='ls -lh --group-directories-first'
alias l='ls -lAh --group-directories-first'
alias lst='ls -lht'
alias lss='ls -lhS'
alias l.='l -d .*'
alias la='l'
alias lla='l'

[[ -f "/etc/motd" ]] && echo -e "$(cat "/etc/motd")"