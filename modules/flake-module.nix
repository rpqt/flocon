{
  flake.nixosModules = {
    gitea.imports = [
      ./gitea.nix
    ];

    desktop.imports = [
      ./desktop.nix
    ];
  };
}
