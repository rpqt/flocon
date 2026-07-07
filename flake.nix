{
  description = "rpqt's Nix configs";

  outputs =
    inputs@{
      clan-core,
      flake-parts,
      self,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        clan-core.flakeModules.default
        inputs.home-manager.flakeModules.home-manager
        ./clan/flake-module.nix
        ./clanServices/flake-module.nix
        ./devShells/flake-module.nix
        ./homeModules/flake-module.nix
        ./infra/flake-module.nix
        ./nixosModules/flake-module.nix
        ./packages/flake-module.nix
        ./flakeModules/flake-module.nix
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      flake.nixosConfigurations.klp1-clanless = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit self; };
        modules = [
          ./machines/klp1/configuration.nix
          ./machines/klp1/hardware-configuration.nix
        ];
      };

      perSystem =
        {
          self',
          lib,
          system,
          ...
        }:
        {
          checks =
            let
              nixosMachines = lib.mapAttrs' (
                name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel
              ) ((lib.filterAttrs (_: config: config.pkgs.system == system)) self.nixosConfigurations);
              blacklistPackages = [
                "genepi-installer-sd-image"
              ];
              packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") (
                lib.filterAttrs (n: _v: !(builtins.elem n blacklistPackages)) self'.packages
              );
              devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self'.devShells;
              homeConfigurations = lib.mapAttrs' (
                name: config: lib.nameValuePair "home-manager-${name}" config.activation-script
              ) (self'.legacyPackages.homeConfigurations or { });
            in
            nixosMachines // packages // devShells // homeConfigurations;
        };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    clan-core.url = "git+https://git.clan.lol/clan/clan-core";
    clan-core.inputs.nixpkgs.follows = "nixpkgs";
    clan-core.inputs.flake-parts.follows = "flake-parts";
    clan-core.inputs.treefmt-nix.follows = "treefmt-nix";

    clan-community.url = "https://git.clan.lol/clan/clan-community/archive/main.tar.gz";
    clan-community.inputs.clan-core.follows = "clan-core";
    clan-community.inputs.flake-parts.follows = "flake-parts";
    clan-community.inputs.treefmt-nix.follows = "treefmt-nix";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    buildbot-nix.url = "github:nix-community/buildbot-nix";
    buildbot-nix.inputs.nixpkgs.follows = "nixpkgs";
    buildbot-nix.inputs.treefmt-nix.follows = "treefmt-nix";

    nixbot.url = "github:Mic92/nixbot";
    nixbot.inputs.nixpkgs.follows = "nixpkgs";
    nixbot.inputs.treefmt-nix.follows = "treefmt-nix";

    direnv-instant.url = "github:Mic92/direnv-instant";
    direnv-instant.inputs.nixpkgs.follows = "nixpkgs";
    direnv-instant.inputs.flake-parts.follows = "flake-parts";
    direnv-instant.inputs.treefmt-nix.follows = "treefmt-nix";

    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
    terranix.inputs.flake-parts.follows = "flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v1.1.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    dms-plugin-registry.url = "github:AvengeMedia/dms-plugin-registry";
    dms-plugin-registry.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };
}
