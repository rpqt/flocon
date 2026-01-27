#!/usr/bin/env bash

set -euox pipefail

HELIX_CONFIG_PATH=$(readlink -f "${HOME}/.config/helix/config.toml")
HELIX_THEME_LIGHT="zed_onelight"
HELIX_THEME_DARK="kanagawa"

ALACRITTY_CONFIG_PATH=$(readlink -f "${HOME}/.config/alacritty/alacritty.toml")
ALACRITTY_THEME_LIGHT="default_light"
ALACRITTY_THEME_DARK="kanagawa_wave"

set_helix_theme() {
  sed -i "s/^theme .*/theme = \"$1\"/" "$HELIX_CONFIG_PATH"
}

set_alacritty_theme() {
  sed -i "s/^import .*/import = \[\"\~\/\.config\/alacritty\/themes\/$1\.toml\"\]/" "$ALACRITTY_CONFIG_PATH"
}

if [[ "$2" == "prefer-dark" ]]; then
  set_helix_theme "$HELIX_THEME_DARK"
  sey_alacritty_theme "$HELIX_THEME_DARK"
else
  set_helix_theme "$HELIX_THEME_LIGHT"
  set_alacritty_theme "$HELIX_THEME_LIGHT"
fi

pkill -USR1 hx || true
