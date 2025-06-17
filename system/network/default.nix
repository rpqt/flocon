{ self, ... }:
{
  imports = [
    self.inputs.nix-topology.nixosModules.default
    ./tailscale.nix
  ];
}
