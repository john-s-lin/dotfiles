# Default host names
darwin_host := "john-mba-03"
nixos_host  := "john-tpd-05"
home_host   := "dietpi@atlas"
work_host   := "work-mbp-01"
nimbus_host := "johnslin@nimbus"

# Run nixos-rebuild switch
nr host=nixos_host:
    sudo nixos-rebuild switch --flake .#{{host}}

# Run darwin-rebuild switch
dr host=darwin_host:
    sudo $(which darwin-rebuild) switch --flake .#{{host}}

# For the work computer
work: (dr work_host)

# For the nimbus server
nimbus: (hm nimbus_host "--impure") 

# Run garbage-collect (default 30 days)
clean days="30":
    sudo $(which nix-collect-garbage) --delete-older-than {{days}}d

# Update nix flake
update:
    nix flake update

# Fetch and rebase onto main, update flake, commit flake.lock (if changed), move main, and push with jj
upgrade message="chore: update flake":
    #!/usr/bin/env bash
    set -euxo pipefail
    jj git fetch
    jj rebase --destination main@origin
    nix flake update
    just check-all
    if [ -z "$(jj diff --name-only flake.lock)" ]; then
        { set +x; } 2>/dev/null
        echo "flake.lock unchanged; nothing to commit or push."
        exit 0
    fi
    jj commit --message {{quote(message)}} flake.lock
    jj bookmark move main --to @-
    jj git push --bookmark main

# Check this machine's flake outputs: evaluates and builds its checks
check:
    nix flake check

# Evaluate Raspberry Pi toplevel and SD image derivations (no builds)
rpi-check:
    #!/usr/bin/env bash
    set -euo pipefail
    for host in apollo atlas; do
        nix eval --raw ".#nixosConfigurations.$host.config.system.build.toplevel.drvPath" > /dev/null
        echo "ok nixosConfigurations.$host (toplevel)"
        nix eval --raw ".#nixosConfigurations.$host.config.system.build.sdImage.drvPath" > /dev/null
        echo "ok nixosConfigurations.$host (sdImage)"
    done

# Evaluate every flake output, across architectures (one nix eval per namespace; no builds)
check-all:
    #!/usr/bin/env bash
    set -euo pipefail
    eval_ns() {
        local ns="$1" expr="$2"
        nix eval --raw ".#$ns" --apply "
          xs:
          builtins.concatStringsSep \"\\n\" (
            builtins.map
              (name: builtins.seq ($expr xs.\${name}) \"ok $ns.\${name}\")
              (builtins.attrNames xs)
          ) + \"\\n\"
        "
    }
    eval_ns nixosConfigurations 'c: c.config.system.build.toplevel.drvPath'
    eval_ns darwinConfigurations 'c: c.system.drvPath'
    eval_ns homeConfigurations 'c: c.activationPackage.drvPath'

# Run home-manager switch
hm host=home_host *options:
    nix run home-manager -- switch --flake .#{{host}} -b bak {{options}}
