{ self, lib, ... }:
{
  clan.modules."@rpqt/prometheus" = lib.modules.importApply ./default.nix { inherit self; };
}
