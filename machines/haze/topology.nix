{
  topology.self = {
    hardware.info = "VivoBook Laptop";
    interfaces = {
      tailscale0 = {
        type = "wireguard";
        network = "tailscale";
        virtual = true;
      };
    };
  };
}
