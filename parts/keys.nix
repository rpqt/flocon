{
  rpqt.haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGa8R8obgptefcp27Cdp9bc2fiyc9x0oTfMsTPFp2ktE rpqt@haze";

  hosts = {
    haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKga5V0H602RsBESBXf5kwRCnI1yfBPOHmjGsM4Rxf5r root@haze";
    genepi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQUzjid5mfMYginIUCVWTF7rWvWz0mUZBZsl5EhDIDl root@genepi";
    crocus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAiz3nzuJGO5tRka2Y/kzqKa68wF7wwHr4hAympLNb9F root@crocus";
    storagebox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";
    storagebox-rsa = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA5EB5p/5Hp3hGW1oHok+PIOH9Pbn7cnUiGmUEBrCVjnAw+HrKyN8bYVV0dIGllswYXwkG/+bgiBlE6IVIBAq+JwVWu1Sss3KarHY3OvFJUXZoZyRRg/Gc/+LRCE7lyKpwWQ70dbelGRyyJFH36eNv6ySXoUYtGkwlU5IVaHPApOxe4LHPZa/qhSRbPo2hwoh0orCtgejRebNtW5nlx00DNFgsvn8Svz2cIYLxsPVzKgUxs8Zxsxgn+Q/UvR7uq4AbAhyBMLxv7DjJ1pc7PJocuTno2Rw9uMZi1gkjbnmiOh6TTXIEWbnroyIhwc8555uto9melEUmWNQ+C+PwAK+MPw==";
  };

  services = {
    radicle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuoHC4P0h88OAL5PJmiqkbkvQR1cwfkjaevWbwdKOU7 radicle@rpqt.fr";
  };
}
