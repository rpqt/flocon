alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias dots=dotfiles
if command -v helix >/dev/null; then
  alias h='helix'
else
  alias h='hx'
fi
if command -v eza >/dev/null; then
  alias ls='eza'
else
  alias ls='ls --color -h'
fi
alias lsa='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias ..='cd ..'
alias ...='cd ../..'
alias bt='bluetoothctl'
alias go='GOPROXY=direct go'
alias ts='tree-sitter'
alias g='git'
alias c='cargo'
alias MAKE='make clean && make'
alias n='myrtle --notebook-dir=$HOME/notes'
