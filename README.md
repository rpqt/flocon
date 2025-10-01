# NixOS & Home Manager config

This repository contains all my system configurations, mostly deployed using Nix and [Clan].

## Structure

- **home**: Dotfiles
- **machines**: Host-specific configs
- **infra**: Terraform/OpenTofu files
- **vars**: Encrypted secrets managed by clan
- **modules**: NixOS modules
- **clanServices**: Custom [Clan Services](https://docs.clan.lol/reference/clanServices)

## Dotfiles

### Linking with dotbotc (for windows)

```sh
dotbot -c ./dotbot/windows.yaml -d home
```

[Clan]: https//clan.lol
