{
  boot.loader = {
    systemd-boot = {
      enable = true;
    };
    efi.canTouchEfiVariables = true;
  };

  console = {
    earlySetup = true;
    useXkbConfig = true;
  };

  services = {
    xserver = {
      xkb.layout = "fr";
    };
  };
}
