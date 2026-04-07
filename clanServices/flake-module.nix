{ lib, ... }:
{
  imports = lib.filter lib.filesystem.pathIsRegularFile (
    map (path: ./${path}/flake-module.nix) (lib.attrNames (lib.readDir ./.))
  );
}
