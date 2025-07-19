{
  description = "rpqt's Nix configs";

  outputs =
    inputs@{
      nixpkgs,
      clan-core,
      flake-parts,
      home-manager,
      impermanence,
      nixos-generators,
      nixos-hardware,
      self,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } ({
      imports = [
        inputs.clan-core.flakeModules.default
        inputs.nix-topology.flakeModule

        ./devShells/flake-module.nix
        ./machines/flake-module.nix
        ./modules/flake-module.nix
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = _: {
        topology.modules = [
          ./topology.nix
        ];
      };

      flake = {
        packages.aarch64-linux.genepi-installer-sd-image = nixos-generators.nixosGenerate {
          specialArgs = {
            inherit inputs;
          };
          system = "aarch64-linux";
          format = "sd-aarch64-installer";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./system/core
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
      };
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators.url = "github:nix-community/nixos-generators";

    clan-core.url = "git+https://git.clan.lol/clan/clan-core";
    clan-core.inputs.nixpkgs.follows = "nixpkgs";
    clan-core.inputs.flake-parts.follows = "flake-parts";

    ignis.url = "github:ignis-sh/ignis";
    ignis.inputs.nixpkgs.follows = "nixpkgs";

    nix-topology.url = "github:oddlama/nix-topology";
    nix-topology.inputs.nixpkgs.follows = "nixpkgs";

    matugen.url = "github:InioX/Matugen";
    matugen.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
