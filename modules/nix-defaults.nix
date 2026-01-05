{ pkgs, ... }:
{
  # for flakes
  environment.systemPackages = [ pkgs.git ];

  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
