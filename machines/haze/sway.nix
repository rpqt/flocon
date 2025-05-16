{
  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  users.users."rpqt".extraGroups = [ "video" ];
  programs.light.enable = true;
}
