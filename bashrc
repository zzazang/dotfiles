#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias pacman='pacman-color'

PS1='[\u@\h \W]\$ '

source "$HOME/.homesick/repos/homeshick/homeshick.sh"