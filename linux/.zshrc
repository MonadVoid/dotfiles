# History (larger history makes zsh-autosuggestions way smarter)
HISTFILE="$HOME/.histfile"
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob notify hist_ignore_all_dups share_history
unsetopt beep nomatch

# Vi keybindings
bindkey -v

# Completion system (single initialization + interactive menu + colors)
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
autoload -Uz compinit && compinit

# Colored CLI aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tree='tree -C'

# Git-aware prompt
zstyle ':vcs_info:git:*' formats ' (%b)'
autoload -Uz vcs_info
precmd() { vcs_info }
setopt prompt_subst
PROMPT='[%F{green}%n@%m%f:%F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f]$ '

# Show fastfetch on interactive shell startup
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# Zsh plugins (installed via pacman: zsh-autosuggestions & zsh-syntax-highlighting)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^y' autosuggest-accept  # Accept suggestion with Ctrl+Y
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
