{
  description = "rpqt's Nix configs";

  outputs =
    inputs@{
      nixpkgs,
      clan-core,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } ({
      imports = [
        clan-core.flakeModules.default
        inputs.terranix.flakeModule
        ./clan/flake-module.nix
        ./clanServices/flake-module.nix
        ./devShells/flake-module.nix
        ./home-manager/flake-module.nix
        ./infra/flake-module.nix
        ./modules/flake-module.nix
        ./packages/flake-module.nix
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators.url = "github:nix-community/nixos-generators";

    clan-core.url = "git+https://git.clan.lol/clan/clan-core";
    clan-core.inputs.nixpkgs.follows = "nixpkgs";
    clan-core.inputs.flake-parts.follows = "flake-parts";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    buildbot-nix.url = "github:nix-community/buildbot-nix";
    buildbot-nix.inputs.nixpkgs.follows = "nixpkgs";

    direnv-instant.url = "github:Mic92/direnv-instant";
    direnv-instant.inputs.nixpkgs.follows = "nixpkgs";
    direnv-instant.inputs.flake-parts.follows = "flake-parts";

    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
    terranix.inputs.flake-parts.follows = "flake-parts";
  };
}
