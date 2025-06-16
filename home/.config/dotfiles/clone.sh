#!/bin/sh

DOTFILES_GIT_URL='git@git.sr.ht:~rpqt/dotfiles'

# The first argument can be the destination folder
if [ $# -eq 1 ]; then
  DOTFILES_DIR="$1"
else
  DOTFILES_DIR="$HOME/.dotfiles"
fi

echo "$DOTFILES_DIR" >> "$HOME/.gitignore"

git clone --bare "$DOTFILES_GIT_URL" "$DOTFILES_DIR"

alias dotfiles='/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME'

dotfiles config --local status.showUntrackedFiles no

dotfiles checkout

tee "$HOME/.config/git/config" >/dev/null <<EOT
[include]
  path = ~/.config/git/common.gitconfig
  path = ~/.config/git/local.gitconfig
EOT

unset DOTFILES_DIR
unset DOTFILES_GIT_URL
