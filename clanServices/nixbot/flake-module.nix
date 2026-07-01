{ self, lib, ... }:
{
  clan.modules."@rpqt/nixbot" = lib.modules.importApply ./default.nix { inherit self; };
}
