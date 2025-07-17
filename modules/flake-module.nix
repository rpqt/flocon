{
  flake.nixosModules = {
    gitea.imports = [
      ./gitea.nix
    ];
  };
}
