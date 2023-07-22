#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

BOLD_BLUE="\033[1;34m"
NC='\033[0m'
SPLASH=$(eval "hyprctl splash")

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias tree='lt'
alias grep='ripgrep'
alias cat="bat"
alias g="lazygit"
alias nv="nvim"
alias n.="nv ."
alias vi="nv"
alias cd="z"
alias fzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

antec3="emeltzer@antec3.panet.utoledo.edu"

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

eval "$(starship init bash)"
eval "$(zoxide init bash)"
echo -e "${BOLD_BLUE}${SPLASH}${NC}\n"
