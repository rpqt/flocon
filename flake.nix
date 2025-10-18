{
  description = "rpqt's Nix configs";

  outputs =
    inputs@{
      nixpkgs,
      clan-core,
      flake-parts,
      home-manager,
      impermanence,
      nixos-hardware,
      self,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } ({
      imports = [
        inputs.clan-core.flakeModules.default

        ./clanServices/flake-module.nix
        ./devShells/flake-module.nix
        ./home-manager/flake-module.nix
        ./machines/flake-module.nix
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

    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators.url = "github:nix-community/nixos-generators";

    clan-core.url = "git+https://git.clan.lol/clan/clan-core";
    clan-core.inputs.nixpkgs.follows = "nixpkgs";
    clan-core.inputs.flake-parts.follows = "flake-parts";

    ignis.url = "github:ignis-sh/ignis";
    ignis.inputs.nixpkgs.follows = "nixpkgs";

    matugen.url = "github:InioX/Matugen";
    matugen.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae.inputs.nixpkgs.follows = "nixpkgs";

    buildbot-nix.url = "github:nix-community/buildbot-nix";
    buildbot-nix.inputs.nixpkgs.follows = "nixpkgs";

    dankMaterialShell.url = "github:AvengeMedia/DankMaterialShell";
    dankMaterialShell.inputs.nixpkgs.follows = "nixpkgs";
  };
}
