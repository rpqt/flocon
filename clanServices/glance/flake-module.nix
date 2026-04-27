{ self, lib, ... }:
{
  clan.modules."@rpqt/glance" = lib.modules.importApply ./default.nix { inherit self; };
}
