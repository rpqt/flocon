# Flocon

This repository contains all my system configurations, mostly deployed using Nix and [Clan].

## Structure

The file hierarchy is based on the flake's structure, using [flake parts] conventions.

- **clan**: Clan configuration
- **clanServices**: Custom [Clan Services](https://docs.clan.lol/reference/clanServices)
- **home**: Dotfiles
- **homeModules**: [Home Manager] modules
- **infra**: [Terranix] files (for Terraform/OpenTofu)
- **machines**: Per-host configurations
- **nixosModules**: [NixOS] modules
- **packages**: Nix packages
- **vars**: Encrypted secrets managed by clan

## Dotfiles

### Linking with dotbotc (for windows)

```sh
dotbot -c ./dotbot/windows.yaml -d home
```

[Clan]: https://clan.lol
[Home Manager]: https://home-manager.dev
[NixOS]: https://nixos.org
[Terranix]: https://terranix.org
[Flake parts]: https://flake.parts
