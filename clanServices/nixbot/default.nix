{ self, ... }:
{ lib, ... }:
{
  _class = "clan.service";
  manifest.name = "nixbot";
  manifest.exports.out = [ "auth" ];

  roles.default = {
    interface.options = {
      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name under which the frontend is reachable";
        example = "https://nixbot.example.com";
      };
      oidcDomain = lib.mkOption {
        type = lib.types.str;
        description = "OIDC domain used for authentication";
        example = "auth.example.com";
      };
      admins = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of usernames allowed to authenticate to the frontend";
        example = [
          "oidc:auth.example.com:rpqt"
        ];
      };
      topic = lib.mkOption {
        type = lib.types.str;
        description = "Name of the topic attached to repositories that should be built";
        example = "buildbot-nix";
      };
      nginx.enableACME = lib.mkOption {
        type = lib.types.bool;
        description = "Request a TLS certificate for the nginx virtual host";
        default = true;
      };
    };

    perInstance =
      {
        settings,
        mkExports,
        ...
      }:
      let
        clientId = "nixbot";
      in
      {
        exports = mkExports {
          auth.client = {
            inherit clientId;
            clientName = "Nixbot";
            redirectUris = [ "https://${settings.domain}/auth/oidc/callback" ];
            public = false;
            scopes = [
              "openid"
              "email"
              "profile"
            ];
          };
          auth.varsGenerator = {
            share = true;
            files.client_secret = { };
            files.client_secret_hash = { };
            script = ''
              mkdir -p $out
              openssl rand -hex 32 > $out/client_secret
              authelia crypto hash generate argon2 --password "$(cat $out/client_secret)" \
                | sed 's/^Digest: //' > $out/client_secret_hash
            '';
          };
        };

        nixosModule =
          {
            config,
            ...
          }:
          {
            imports = [
              self.inputs.nixbot.nixosModules.nixbot
            ];

            services.nixbot = {
              enable = true;
              inherit (settings) domain admins nginx;

              oidc = {
                enable = true;
                name = "Authelia";
                discoveryUrl = "https://${settings.oidcDomain}/.well-known/openid-configuration";
                inherit clientId;
                clientSecretFile =
                  config.clan.core.vars.generators."authelia-oidc-${clientId}".files.client_secret.path; # TODO: make it provider-agnostic
                mapping.username = "preferred_username";
              };

              gitea = {
                enable = true;
                instanceUrl = "https://git.rpqt.fr";

                tokenFile = config.clan.core.vars.generators.nixbot.files.api-token.path;
                oauthId = config.clan.core.vars.generators.nixbot.files.oauth-id.value;
                oauthSecretFile = config.clan.core.vars.generators.nixbot.files.oauth-secret.path;

                userAllowlist = [ "rpqt" ];
                topic = "build-with-nixbot";
              };
            };

            clan.core.vars.generators.nixbot = {
              prompts.api-token = {
                description = "Gitea API token";
                type = "hidden";
                persist = true;
              };
              prompts.oauth-id = {
                description = "OAuth client ID";
                persist = true;
              };
              files.oauth-id.secret = false;
              prompts.oauth-secret = {
                description = "OAuth client secret";
                type = "hidden";
                persist = true;
              };
            };
          };
      };
  };
}
