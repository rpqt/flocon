{ inputs, self, ... }:
{
  flake.packages.aarch64-linux.genepi-installer-sd-image = inputs.nixos-generators.nixosGenerate {
    specialArgs = {
      inherit inputs;
    };
    system = "aarch64-linux";
    format = "sd-aarch64-installer";
    modules = [
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      self.nixosModules.common
      self.nixosModules.hardened-ssh-server
      ./machines/genepi/network.nix
      ./machines/genepi/hardware-configuration.nix
      { networking.hostName = "genepi"; }
      { sdImage.compressImage = false; }
      {
        nixpkgs.overlays = [
          (final: super: {
            makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
          })
        ];
      }
    ];
  };
}
