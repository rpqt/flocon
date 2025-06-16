# Path
source ~/.config/sh/path.sh

# Aliases
source ~/.config/sh/aliases.sh

# Completion
autoload -Uz compinit
compinit
# sudo completion
zstyle ':completion::complete:*' gain-privileges 1

# Line movement with special keys
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

source ~/.config/zsh/hooks.sh

if [ -r ~/.profile ]; then
  source ~/.profile
fi

# Load machine-specific config
if [ -r ~/.config/zsh/$HOST.zsh ]; then
  source ~/.config/zsh/$HOST.zsh
fi
