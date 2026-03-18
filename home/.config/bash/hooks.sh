# Hook direnv if present
if command -v direnv >/dev/null; then
  eval "$(direnv hook bash)"
fi

# Prompt
if command -v starship >/dev/null; then
  source <(starship init bash)
fi

# Launch atuin if it is installed
if command -v atuin >/dev/null; then
  eval "$(atuin init bash)"
fi

# Init zoxide if present and alias cd to it
if command -v zoxide >/dev/null; then
  eval "$(zoxide init bash)"
  alias cd=z
fi
