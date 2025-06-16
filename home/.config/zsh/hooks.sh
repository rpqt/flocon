# Hook direnv if present
if command -v direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi

# Prompt
if command -v starship >/dev/null; then
  source <(starship init zsh)
fi

# Load opam config if present
if [ -r ~/.opam/opam-init/init.zsh ]; then
  source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
fi

# Launch atuin if it is installed
if command -v atuin >/dev/null; then
  eval "$(atuin init zsh)"
fi

# Set ls/tree/fd theme using vivid if it is installed
if command -v vivid >/dev/null; then
  export LS_COLORS="$(vivid generate gruvbox-dark-hard)"
fi

# Init zoxide if present and alias cd to it
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd=z
fi
