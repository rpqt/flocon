# Infra

## Secrets

Provide secrets when asked by the command-line, or save them in a `terraform.tfvars` file:

``` hcl
gandi_token = XXX
hcloud_token = YYY
```

## Importing

To import already existent resources, use the `import` command:

```
tofu import hcloud_server.crocus_server XXX
tofu import hcloud_firewall.hcloud_firewall YYY
```

For Hetzner Cloud, the resource IDs can be found in the URL of the admin console.

## Outputs

The nix configuration reads some values from the `outputs.json` file.
When modifying these, the file should be regenerated with `tofu output -json > outputs.json`.
