# Setting up network DNS on local, when setting up DNS on a router is not an option

This runbook describes the command line option for `macOS` for setting up DNS locally, if setting up DNS through the router is not an option (for example, when other users prefer their own DNS/prefer default settings)

In the terminal, run

```bash
networksetup -getdnsservers wi-fi # To view DNS servers connected through Wi-Fi en0
```

To setup your custom upstream DNS provider, run

```bash
networksetup -setdnsservers wi-fi <dns1> <dns2> ... <dns_n> # To set DNS server

# Example: setting up 1.1.1.1 Cloudflare DNS
networksetup -setdnsservers wi-fi 1.1.1.1 1.0.0.1
```

# Removing old wireless networks if you no longer intend to use them

To remove old wireless networks that you no longer recognize and want to connect to, you can run

```bash
# en0 = wi-fi
networksetup -listpreferredwirelessnetworks en0

# Find your target network you want to drop, then
networksetup -removepreferredwirelessnetwork en0 <SSID>
# If SSID is a multi-word string with spaces, use double quotes. e.g. "Toronto Public Library"
networksetup -removedpreferredwirelessnetwork en0 "Toronto Public Library"
```
