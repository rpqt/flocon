{ self, lib, ... }:
{
  clan.modules."@rpqt/vaultwarden" = lib.modules.importApply ./default.nix { inherit self; };
}
