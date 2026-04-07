{ self, lib, ... }:
{
  clan.modules."@rpqt/home-assistant" = lib.modules.importApply ./default.nix { inherit self; };
}
