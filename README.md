# NixOS & Home Manager config

## Structure

- **home**: Home Manager modules
- **hosts**: Host-specific configs
- **infra**: Terraform/OpenTofu files
- **secrets**: Age-encrypted secrets shared between multiple hosts.
  Host-specific secrets are stored in their own directories.
- **system**: Base NixOS modules shared among all hosts
