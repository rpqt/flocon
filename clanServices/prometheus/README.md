This module enables collecting metrics from machines in clan, using Prometheus.

There are two roles:

- A `target` role for machines on which to collect and export metrics.
- A `scraper` roles for machines that fetch metrics from `target` machines and
  store them in the long term.


```nix
inventory = {

  machines = {
    server01.tags.server = {};
    server02.tags.server = {};
    metrics.tags.server = {}; # metrics collector
  };

  instances = {
    prometheus = {
      module.name = "@rpqt/prometheus";
      module.input = "self";

      roles.scraper.machines."metrics" = {};

      # Collect metrics on all servers
      roles.target.tags.server = {
        settings = {
          exporters = {
            # Enable the node-exporter metrics source
            node.enabledCollectors = [ "systemd" ];
          };
        };
      };
    };
  };
};
```
