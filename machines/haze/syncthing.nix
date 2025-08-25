{
  config,
  lib,
  ...
}:
let
  user = "rpqt";
  home = config.users.users.${user}.home;
in
{
  services.syncthing = {
    enable = true;
    user = user;
    group = lib.mkForce "users";
    dataDir = home;
    configDir = lib.mkForce "${home}/.config/syncthing";
  };
}
