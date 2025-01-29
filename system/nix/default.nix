{ pkgs, ... }:
{
  imports = [
    ./nixpkgs.nix
    ./substituters.nix
  ];

  # for flakes
  environment.systemPackages = [ pkgs.git ];

  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = ["nix-command" "flakes"];

    trusted-users = ["root" "@wheel"];
  };
}
