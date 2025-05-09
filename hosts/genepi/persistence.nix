{ lib, ... }:
{
  environment.persistence."/persist" = {
    enable = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/acme"
      "/var/lib/prometheus2"
      "/var/lib/immich"
      "/var/lib/redis-immich"
      "/var/lib/postgresql"
      "/var/lib/grafana"
      "/var/lib/freshrss"
    ];
    files = [
      # so that systemd doesn't think each boot is the first
      "/etc/machine-id"
      # ssh host keys
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      # tailscale
      "/var/lib/tailscale/tailscaled.state"
    ];
    users.rpqt = {
      directories = [ ];
      files = [ ];
    };
  };

  # Empty root and remove snapshots older than 30 days
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-label/nixos /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
    rmdir /btrfs_tmp
  '';

  # Give agenix persistent paths so it can load secrets before the mount
  age.identityPaths = [
    "/persist/etc/ssh/ssh_host_ed25519_key"
    "/persist/etc/ssh/ssh_host_rsa_key"
  ];
}
