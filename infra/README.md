# Infra

External infrastructure managed with [terranix];
See the [terranix docs](https://terranix.org/docs/getting-started/flake-modules/#what-you-get).

## Usage

Just enter this directory's devShell with `direnv` or `nix develop .#infra`.
Then you can run wrapper executable like `plan`, `apply` or `destroy`.

From the repository root there are also flake apps like `nix run .#infra.apply`.
 
## Secrets

Secrets are stored and retrieved with `clan secrets` and exposed as environment variables in the devShell.

## Importing

Since there are many imports this is a pain so try to keep `terraform.tfstate` around.

Otherwise to import existing resources:

```
tofu import hcloud_server.crocus_server XXX
tofu import hcloud_firewall.hcloud_firewall YYY
```

For Hetzner Cloud, the resource IDs can be found in the URL from the [admin console](https://console.hetzner.com/).

## Outputs

The nix configuration reads some values from the `outputs.json` file.
When modifying these, the file should be regenerated with `tofu output -json > outputs.json`.

[terranix]: https://terranix.org/
