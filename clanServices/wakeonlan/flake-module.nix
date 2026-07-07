{ self, lib, ... }: {
  clan.modules."@shallerclan/wakeonlan" = lib.modules.importApply ./default.nix { inherit self; };
}
