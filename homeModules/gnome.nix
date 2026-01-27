{ pkgs, ... }:
{
  home.packages = with pkgs.gnomeExtensions; [
    blur-my-shell
    paperwm
  ];

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      show-image-thumbnails = "always";
    };
  };
}
