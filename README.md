# Flocon

This repository contains all my system configurations, mostly deployed using Nix and [Clan].

## Structure

- **clan**: Clan configuration
- **clanServices**: Custom [Clan Services](https://docs.clan.lol/reference/clanServices)
- **home**: Dotfiles
- **home-manager**: [Home Manager] modules
- **infra**: [Terranix] files (for Terraform/OpenTofu)
- **machines**: Per-host configurations
- **modules**: [NixOS] modules
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
