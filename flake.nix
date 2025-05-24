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
