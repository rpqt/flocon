{
  networking.hostName = "genepi";

  # Tailscale seems to break when not using resolved
  services.resolved.enable = true;
  networking.useDHCP = true;
  networking.interfaces.tailscale0.useDHCP = false;
}
