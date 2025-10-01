{ self, ... }:
{ lib, ... }:
{
  _class = "clan.service";
  manifest.name = "buildbot";

  roles.master = {
    interface.options = {
      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name under which the buildbot frontend is reachable";
        example = "https://buildbot.example.com";
      };
      admins = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of usernames allowed to authenticate to the buildbot frontend";
        example = [ "Mic92" ];
      };
      topic = lib.mkOption {
        type = lib.types.str;
        description = "Name of the topic attached to repositories that should be built";
        example = "buildbot-nix";
      };
      gitea.instanceUrl = lib.mkOption {
        type = lib.types.str;
        description = "URL of the Gitea instance";
        example = "https://git.example.com";
      };
    };

    perInstance =
      {
        settings,
        roles,
        ...
      }:
      {
        nixosModule =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            imports = [
              self.inputs.buildbot-nix.nixosModules.buildbot-master
            ];

            services.buildbot-nix.master = {
              enable = true;
              workersFile = config.clan.core.vars.generators.buildbot.files.workers-file.path;
              inherit (settings) domain admins;

              authBackend = "gitea";
              gitea = {
                enable = true;
                inherit (settings.gitea) instanceUrl;
                inherit (settings) topic;

                tokenFile = config.clan.core.vars.generators.buildbot.files.api-token.path;
                webhookSecretFile = config.clan.core.vars.generators.buildbot.files.webhook-secret.path;

                oauthId = config.clan.core.vars.generators.buildbot.files.oauth-id.value;
                oauthSecretFile = config.clan.core.vars.generators.buildbot.files.oauth-secret.path;
              };
            };

            clan.core.vars.generators.buildbot = {
              prompts.api-token = {
                description = "gitea API token";
                type = "hidden";
                persist = true;
              };
              prompts.webhook-secret = {
                description = "gitea webhook secret";
                type = "hidden";
                persist = true;
              };
              prompts.oauth-id = {
                description = "oauth client id";
                persist = true;
              };
              files.oauth-id.secret = false;
              prompts.oauth-secret = {
                description = "oauth secret";
                type = "hidden";
                persist = true;
              };

              dependencies = [ "buildbot-worker" ];
              files.workers-file.secret = true;
              runtimeInputs = [ pkgs.python3 ];
              script = ''
                python3 - << EOF                
                import os
                import json

                password_path = os.path.join(os.environ.get("in"), "buildbot-worker/worker-password")
                password = open(password_path).read().strip()

                workers = [
                  {
                    "name": "${config.networking.hostName}",
                    "pass": password,
                    "cores": 4,
                  },
                ];

                workers_file_path = os.path.join(os.environ.get("out"), "workers-file")
                with open(workers_file_path, "w") as workers_file:
                  workers_file.write(json.dumps(workers))

                EOF
              '';
            };
          };
      };
  };

  roles.worker = {
    perInstance =
      {
        settings,
        roles,
        ...
      }:
      {
        nixosModule =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            imports = [
              self.inputs.buildbot-nix.nixosModules.buildbot-worker
            ];

            services.buildbot-nix.worker = {
              enable = true;
              workerPasswordFile = config.clan.core.vars.generators.buildbot-worker.files.worker-password.path;
            };

            clan.core.vars.generators.buildbot-worker = {
              files.worker-password = { };
              runtimeInputs = [
                pkgs.openssl
              ];
              script = ''
                openssl rand -hex 32 > "$out"/worker-password
              '';
            };
          };
      };
  };
}
