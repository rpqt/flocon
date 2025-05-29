{
  topology.self = {
    hardware.info = "x86_64 VPS";
    interfaces = {
      tailscale0 = {
        type = "wireguard";
        network = "tailscale";
      };
    };
  };
}
