{
  description = "rpqt's Nix configs";

  outputs =
    inputs@{
      nixpkgs,
      deploy-rs,
      home-manager,
      impermanence,
      nixos-generators,
      nixos-hardware,
      self,
      ...
    }:
    {
      nixosConfigurations = {

        # VivoBook laptop
        haze = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit (import ./parts) keys;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/haze
            ./system
          ];
        };

        # Hetzner VPS
        crocus = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit (import ./parts) keys;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/crocus
            ./system
          ];
        };

        # Raspberry Pi 4
        genepi = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs self;
            inherit (import ./parts) keys;
          };
          system = "aarch64-linux";
          modules = [
            ./hosts/genepi
            ./system
          ];
        };

      };

      # Raspberry Pi 4 installer ISO.
      packages.aarch64-linux.installer-sd-image = nixos-generators.nixosGenerate {
        specialArgs = {
          inherit inputs;
          inherit (import ./parts) keys;
        };
        system = "aarch64-linux";
        format = "sd-aarch64-installer";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          ./system/core
          ./hosts/genepi/network.nix
          ./hosts/genepi/hardware.nix
          {
            nixpkgs.overlays = [
              (final: super: {
                makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
              })
            ];
          }
        ];
      };

      homeConfigurations = {
        "rpqt@haze" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
          };
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./hosts/haze/home.nix
          ];
        };
      };

      deploy.nodes.crocus = {
        hostname = "crocus";
        profiles = {
          system = {
            user = "root";
            sshUser = "rpqt";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.crocus;
          };
        };
      };

      deploy.nodes.genepi = {
        hostname = "genepi";
        profiles = {
          system = {
            user = "root";
            sshUser = "rpqt";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.genepi;
            remoteBuild = true;
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShells =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          "${system}".default = pkgs.mkShell {
            packages = [
              pkgs.terraform-ls
              pkgs.deploy-rs
              pkgs.zsh
            ];
            shellhook = ''
              exec zsh
            '';
          };
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
    deploy-rs = {
      url = "github:serokell/deploy-rs";
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
