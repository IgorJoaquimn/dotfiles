# Set up Starship
eval "$(starship init zsh)"

# History configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Keybindings (Vim mode)
bindkey -v

# Zsh Plugins (Arch Linux paths)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Note: zsh-completions is usually handled by adding to fpath
fpath=(/usr/share/zsh/site-functions $fpath)

# Initialize completion system
autoload -Uz compinit
compinit

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
