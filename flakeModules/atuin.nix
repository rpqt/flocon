{
  flake.nixosModules.atuin-config = {
    clan.core.vars.generators.atuin = {
      prompts.key.persist = true;
      files.key.owner = "rpqt";
    };
  };

  flake.homeModules.atuin-config =
    { config, osConfig, ... }:
    {
      programs.atuin.enable = true;
      xdg.dataFile."atuin/key".source =
        config.lib.file.mkOutOfStoreSymlink osConfig.clan.core.vars.generators.atuin.files.key.path;
    };
}
