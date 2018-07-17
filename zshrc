#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export PATH=$PATH:$HOME/bin
export PATH=~/.local/bin:$PATH

#user aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias tclock='tty-clock -tsc'
alias gup='git checkout master && git fetch upstream && git reset --hard upstream/master'
alias dup='git checkout dev && git fetch upstream && git reset --hard upstream/dev'
alias vtop='vtop --theme brew'
alias reload='source ~/.zshrc'
alias tcat='curl -v http://vaasv001p.prod.appia.com:8080/recachePropertyTomcat\?key\=r3c@che4t0mc@t'
alias topmem='ps -eo pmem,pcpu,vsize,pid,cmd | sort -k 1 -nr | head -5'

#tmux aliases:

alias tn='tmux new-session -s'
alias ta='tmux attach -t'
alias tl='tmux ls'
alias tk='tmux kill-session -t'
alias tson='tmux set status on'
alias tsoff='tmux set status off'
alias trn='tmux rename-window'
alias work='tmux new-session -s home -d && tmux new-session -s programming -d && tmux new-session -s puppet -d && tmux new-session -s kubernetes -d && tmux new-session -s terraform -d && tmux new-session -s awscli -d && tmux new-session -s sys_admin -d'
fortune|cowsay|lolcat