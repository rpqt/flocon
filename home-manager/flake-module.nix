{
  flake.homeManagerModules = {
    dotfiles.imports = [ ./dotfiles.nix ];
  };
}
