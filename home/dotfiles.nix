{ config, lib, ... }:
{
  options = {
    dotfiles = {
      path = lib.mkOption {
        type = lib.types.path;
        apply = toString;
        default = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/rep/dotfiles";
        example = "${config.home.homeDirectory}/.dotfiles";
        description = "Location of the dotfiles working copy";
      };
    };
  };
}
