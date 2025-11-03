#!/usr/bin/env bash

set -euox pipefail

HELIX_CONFIG_PATH=$(readlink -f "${HOME}/.config/helix/config.toml")
HELIX_THEME_LIGHT="zed_onelight"
HELIX_THEME_DARK="kanagawa"

if [[ "$2" == "prefer-dark" ]]; then
  sed -i "s/^theme .*/theme = \"$HELIX_THEME_DARK\"/" "$HELIX_CONFIG_PATH"
else
  sed -i "s/^theme .*/theme = \"$HELIX_THEME_LIGHT\"/" "$HELIX_CONFIG_PATH"
fi

pkill -USR1 hx || true
