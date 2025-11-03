#!/usr/bin/env sh

gsettings monitor org.gnome.desktop.interface color-scheme \
  | xargs -L1 "${HOME}/rep/flocon/home/bin/switch-helix-theme.sh"
