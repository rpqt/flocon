{
  self,
  pkgs,
  config,
  ...
}:
{
  imports = [ self.inputs.dms-plugin-registry.modules.default ];

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    playerctl
    xwayland-satellite
  ];

  services.gnome.gnome-keyring.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.dms-shell = {
    enable = true;
    plugins = {
      dankBatteryAlerts.enable = config.services.upower.enable;
      dankHooks.enable = true;
      dankKDEConnect.enable = true;
      musicLyrics.enable = true;
    };
  };
}
