{ config, ... }:
let
  pass = "passage";
in
{
  programs.thunderbird = {
    enable = true;
    profiles = {
      main = {
        isDefault = true;
      };
    };
  };

  programs.aerc = {
    enable = true;
    # safe since the accounts file just contains commands for retrieving passwords and is readonly in the nix store
    extraConfig.general.unsafe-accounts-conf = true;
  };

  accounts.email.accounts = {
    "rpqt@rpqt.fr" = rec {
      address = "rpqt@rpqt.fr";
      realName = "Romain Paquet";
      primary = true;
      flavor = "migadu.com";
      thunderbird.enable = config.programs.thunderbird.enable;
      aerc.enable = config.programs.aerc.enable;
      passwordCommand = [
        pass
        "show"
        "mail/${address}"
      ];
      folders.inbox = "INBOX";
    };

    "admin@rpqt.fr" = rec {
      address = "admin@rpqt.fr";
      aliases = [ "postmaster@rpqt.fr" ];
      realName = "Postmaster";
      flavor = "migadu.com";
      thunderbird.enable = config.programs.thunderbird.enable;
      aerc.enable = config.programs.aerc.enable;
      passwordCommand = [
        pass
        "show"
        "mail/${address}"
      ];
      folders.inbox = "INBOX";
    };

    "romain.paquet@grenoble-inp.org" = rec {
      address = "romain.paquet@grenoble-inp.org";
      realName = "Romain Paquet";
      userName = "romain.paquet@grenoble-inp.org";
      imap = {
        host = "imap.partage.renater.fr";
        port = 993;
      };
      smtp = {
        host = "smtp.partage.renater.fr";
        port = 465;
      };
      thunderbird.enable = config.programs.thunderbird.enable;
      aerc.enable = config.programs.aerc.enable;
      passwordCommand = [
        pass
        "show"
        "mail/${address}"
      ];
      folders.inbox = "INBOX";
    };

    "admin@turifer.dev" = rec {
      address = "admin@turifer.dev";
      aliases = [ "postmaster@turifer.dev" ];
      realName = "Postmaster";
      flavor = "migadu.com";
      thunderbird.enable = config.programs.thunderbird.enable;
      aerc.enable = config.programs.aerc.enable;
      passwordCommand = [
        pass
        "mail/${address}"
      ];
    };

    "romain@student.agh.edu.pl" = {
      address = "romain@student.agh.edu.pl";
      aliases = [ "382799@student.agh.edu.pl" ];
      realName = "Romain Paquet";
      userName = "romain@student.agh.edu.pl";
      imap = {
        host = "poczta.agh.edu.pl";
        port = 993;
      };
      smtp = {
        host = "poczta.agh.edu.pl";
        port = 465;
      };
      thunderbird.enable = config.programs.thunderbird.enable;
    };

    "romain.pqt@gmail.com" = {
      address = "romain.pqt@gmail.com";
      realName = "Romain Paquet";
      flavor = "gmail.com";
      thunderbird.enable = config.programs.thunderbird.enable;
    };
  };
}
