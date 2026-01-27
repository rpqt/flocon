{ lib, ... }:
{
  flake.nixosModules =
    (
      (builtins.readDir ./.)
      |> lib.filterAttrs (path: type: type == "regular" && (lib.hasSuffix ".nix" path))
      |> lib.mapAttrs' (
        path: _: {
          name = lib.removeSuffix ".nix" path;
          value = {
            imports = [ ./${path} ];
          };
        }
      )
    )
    // {
      server.imports = [
        ./motd.nix
      ];

      common.imports = [
        {
          users.mutableUsers = lib.mkDefault false;
          services.userborn.enable = lib.mkDefault true;
        }
      ];
    };
}
