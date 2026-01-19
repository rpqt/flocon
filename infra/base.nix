{
  config,
  lib,
  pkgs,
  ...
}:
{
  terraform.required_providers.hcloud.source = "hetznercloud/hcloud";

  data.external.hcloud-token = {
    program = [
      (lib.getExe (
        pkgs.writeShellApplication {
          name = "get-clan-secret";
          text = ''
            jq -n --arg secret "$(clan secrets get hcloud-token)" '{"secret":$secret}'
          '';
        }
      ))
    ];
  };

  provider.hcloud.token = config.data.external.hcloud-token "result.secret";
}
