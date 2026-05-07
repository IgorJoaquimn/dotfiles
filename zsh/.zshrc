# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set up Starship
eval "$(starship init zsh)"

# History configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Keybindings (Vim mode)
bindkey -v

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'
alias v='nvim'
alias g='git'

# Source local config if it exists
[[ -f ~/.zshrc_local ]] && source ~/.zshrc_local

# Source bash editor config if shared
[[ -f ~/.config/bash/.bashrc_editor ]] && source ~/.config/bash/.bashrc_editor
