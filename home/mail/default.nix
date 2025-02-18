{ config, ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles = {
      main = {
        isDefault = true;
      };
    };
  };

  accounts.email.accounts = {
    "rpqt@rpqt.fr" = {
      address = "rpqt@rpqt.fr";
      realName = "Romain Paquet";
      primary = true;
      flavor = "migadu.com";
      thunderbird.enable = true;
    };

    "admin@rpqt.fr" = {
      address = "admin@rpqt.fr";
      aliases = [ "postmaster@rpqt.fr" ];
      realName = "Postmaster";
      flavor = "migadu.com";
      thunderbird.enable = config.programs.thunderbird.enable;
    };

    "romain.paquet@grenoble-inp.org" = {
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
    };
  };
}
