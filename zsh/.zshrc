# Set up Starship
eval "$(starship init zsh)"

# Zinit Installation
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Zinit Plugins
zinit light Aloxaf/fzf-tab

# History configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Keybindings (Vim mode)
bindkey -v

# Zsh Plugins (Arch Linux paths)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Customize Syntax Highlighting
ZSH_HIGHLIGHT_STYLES[unknown-token]='none'
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[path_prefix]='none'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'

# fzf setup
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

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
