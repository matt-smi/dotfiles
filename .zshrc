# Oh My Zsh Configuration

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

eval "$(starship init zsh)"
