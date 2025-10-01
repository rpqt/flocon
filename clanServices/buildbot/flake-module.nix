{ self, lib, ... }:
{
  clan.modules."@rpqt/buildbot" = lib.modules.importApply ./default.nix { inherit self; };
}
