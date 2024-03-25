# Setting up network DNS on local, when setting up DNS on a router is not an option

This runbook describes the command line option for `macOS` for setting up DNS locally, if setting up DNS through the router is not an option (for example, when other users prefer their own DNS/prefer default settings)

In the terminal, run

```bash
networksetup -getdnsservers wi-fi # To view DNS servers connected through Wi-Fi en0
```

To setup your custom DNS urls, run

```bash
networksetup -setdnsservers wi-fi <dns1> <dns2> ... <dns_n> # To set DNS server

# Example setting up 1.1.1.1 Cloudflare
networksetup -setdnsservers wi-fi 1.1.1.1 1.0.0.1
```
