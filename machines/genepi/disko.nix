{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/ata-WD_Green_M.2_2280_480GB_2251E6411147";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1M";
          end = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          end = "-4G";
          content = {
            type = "btrfs";
            extraArgs = [
              "-L"
              "nixos"
              "-f" # Override existing partition
            ];
            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = [
                  "subvol=root"
                  "compress=zstd"
                  "noatime"
                ];
              };
              "/home" = {
                mountpoint = "/home";
                mountOptions = [
                  "subvol=home"
                  "compress=zstd"
                  "noatime"
                ];
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "subvol=nix"
                  "compress=zstd"
                  "noatime"
                ];
              };
              "/persist" = {
                mountpoint = "/persist";
                mountOptions = [
                  "subvol=persist"
                  "compress=zstd"
                  "noatime"
                ];
              };
              "/log" = {
                mountpoint = "/var/log";
                mountOptions = [
                  "subvol=log"
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
        swap = {
          size = "100%";
          content = {
            type = "swap";
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
