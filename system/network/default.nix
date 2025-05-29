{ inputs, ... }:
{
  imports = [
    inputs.nix-topology.nixosModules.default
    ./tailscale.nix
  ];
}
