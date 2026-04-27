{
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-linux";

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.supportedFilesystems = {
    vfat = true;
    zfs = lib.mkForce false;
  };
}
