{
  imports = [
    ../../modules/remote-builder.nix
  ];

  roles.remote-builder = {
    enable = true;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGa8R8obgptefcp27Cdp9bc2fiyc9x0oTfMsTPFp2ktE rpqt@haze"
    ];
  };
}
