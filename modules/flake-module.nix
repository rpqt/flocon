{ lib, ... }:
{
  flake.nixosModules = {
    gitea.imports = [
      ./gitea.nix
    ];

    desktop.imports = [
      ./desktop.nix
    ];

    nix-defaults.imports = [ ./nix-defaults.nix ];
    tailscale.imports = [ ./tailscale.nix ];
    user-rpqt.imports = [ ./user-rpqt.nix ];
    hardened-ssh-server.imports = [ ./hardened-ssh-server.nix ];
    nextcloud.imports = [ ./nextcloud.nix ];

    common.imports = [
      {
        users.mutableUsers = lib.mkDefault false;
        services.userborn.enable = lib.mkDefault true;
      }
    ];
  };
}
