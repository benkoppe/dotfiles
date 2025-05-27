alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

alias q=exit
alias clr=clear
alias please='sudo '
alias purge='rm -rf'
# Copy with permissions
alias cp='rsync -a'
# Copy compressed with permissions
alias ccp='rsync -az'
alias cat='bat -Pp'

alias ccd='(){ mkdir -p "$1"; cd "$1";}'
alias cdc='cd ${XDG_CONFIG_HOME}'

alias clipin='xclip -sel clip -i'
alias clipout='xclip -sel clip -o'

# scan wireless networks for connected devices
alias scan="sudo nmap -sn 192.168.8.0/24 | sed -e 's#.*for \(\)#\1#' | sed '/^Host/d' | sed '/MAC/{G;}'"
# find largest files in directory
alias ducks="sudo du -cks -- * | sort -rn | head"

alias ls="ls --color=auto --hyperlink=auto"
alias l="ls -1 -g"

alias python="python3"
alias tmux-s="tmux-sessionizer"
alias ts="tmux-sessionizer"

autoload -U zmv
