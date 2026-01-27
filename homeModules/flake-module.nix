{ lib, ... }:
{
  flake.homeModules =
    (builtins.readDir ./.)
    |> lib.filterAttrs (
      path: type:
      (type == "directory" && lib.filesystem.pathIsRegularFile (./${path}/default.nix))
      || (type == "regular" && (lib.hasSuffix ".nix" path))
    )
    |> lib.mapAttrs' (
      path: type:
      if type == "directory" then
        {
          name = path;
          value = {
            imports = [ ./${path} ];
          };
        }
      else
        {
          name = lib.removeSuffix ".nix" path;
          value = {
            imports = [ ./${path} ];
          };
        }
    );
}
