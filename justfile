# Default host names
darwin_host := "john-mba-03"
nixos_host  := "john-tpd-05"
home_host   := "dietpi@atlas"
home_impure := ""

# Run nixos-rebuild switch
nr host=nixos_host:
    sudo nixos-rebuild switch --flake .#{{host}}

# Run darwin-rebuild switch
dr host=darwin_host:
    sudo $(which darwin-rebuild) switch --flake .#{{host}}

# Run garbage-collect (default 30 days)
gc days="30":
    sudo $(which nix-collect-garbage) --delete-older-than {{days}}d

# Update nix flake
update:
    nix flake update

# Run nix flake check
check:
    nix flake check

# Run home-manager switch
hm host=home_host backup="backup" impure=home_impure:
    #!/usr/bin/env bash
    args=()
    if [ "{{impure}}" = "impure" ]; then
        args+=("--impure")
    fi
    if [ "{{backup}}" = "backup" ]; then
        args+=("-b" "bak")
    fi
    nix run home-manager -- switch --flake .#{{host}} "${args[@]}"
