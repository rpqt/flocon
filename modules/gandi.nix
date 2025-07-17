{
  clan.core.vars.generators.gandi = {
    prompts.gandi-token = {
      description = "gandi access token";
      type = "hidden";
    };
    files.gandi-env = {
      secret = true;
    };
    script = ''
      printf %s "GANDIV5_PERSONAL_ACCESS_TOKEN=" >> $out/gandi-env
      cat $prompts/gandi-token >> $out/gandi-env
    '';
  };
}
