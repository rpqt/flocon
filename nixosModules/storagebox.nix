let
  user = "u422292";
  host = "${user}.your-storagebox.de";
in
{
  programs.ssh.knownHosts = {
    storagebox-ed25519 = {
      hostNames = [ "[${host}]:23" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";
    };
  };
}
