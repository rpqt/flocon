{
  description = "rpqt's Nix configs";

  outputs =
    inputs@{
      nixpkgs,
      clan-core,
      home-manager,
      impermanence,
      nixos-generators,
      nixos-hardware,
      self,
      ...
    }:
    let
      clan = clan-core.lib.buildClan {
        self = self;
        meta.name = "blossom";
        specialArgs = {
          inherit inputs self;
          inherit (import ./parts) keys;
        };
        inventory = {
          instances = {
            "rpqt-admin" = {
              module.input = "clan-core";
              module.name = "admin";
              roles.default.machines = {
                "crocus" = { };
                "genepi" = { };
                "haze" = { };
              };
              roles.default.settings.allowedKeys = {
                rpqt_haze = (import ./parts).keys.rpqt.haze;
              };
            };
          };
          services = {
            zerotier.default = {
              roles.controller.machines = [
                "crocus"
              ];
              roles.peer.machines = [
                "haze"
                "genepi"
              ];
            };
            sshd.default = {
              roles.server.machines = [ "crocus" ];
            };
            user-password.rpqt = {
              roles.default.machines = [
                "crocus"
                "genepi"
                "haze"
              ];
              config.user = "rpqt";
            };
          };
        };
      };
    in
    {
      inherit (clan) clanInternals nixosConfigurations;

      devShells =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
          ]
          (
            system:
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            {
              default = pkgs.mkShell {
                packages = [
                  inputs.agenix.packages.${system}.default
                  clan-core.packages.${system}.clan-cli
                  pkgs.nil # Nix language server
                  pkgs.nixfmt-rfc-style
                  pkgs.opentofu
                  pkgs.terraform-ls
                  pkgs.deploy-rs
                  pkgs.zsh
                ];
                shellhook = ''
                  exec zsh
                '';
              };
            }
          );

      topology =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
          ]
          (
            system:
            let
              pkgs = import nixpkgs {
                inherit system;
                overlays = [ inputs.nix-topology.overlays.default ];
              };
            in
            import inputs.nix-topology {
              inherit pkgs;
              modules = [
                { inherit (self) nixosConfigurations; }
                ./topology.nix
              ];
            }
          );

      packages.aarch64-linux.genepi-installer-sd-image = nixos-generators.nixosGenerate {
        specialArgs = {
          inherit inputs;
          inherit (import ./parts) keys;
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

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    clan-core = {
      url = "git+https://git.clan.lol/clan/clan-core";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ignis = {
      url = "github:ignis-sh/ignis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
