#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Show Fastfetch on terminal start
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi
. "$HOME/.cargo/env"
