# .dotfiles

Main setup files for all programs on a new developer machine. `.zshrc` will work for `x86_64` and `arm64` Macs and can be ported without modification.

This is largely one-touch deployment for Darwin (macOS) systems.

## Setup

Make sure to first install `xcode-select` CLI on macOS.

```bash
# On macOS only
xcode-select --install
```

Then clone this repo!

Make sure `install.sh` is executable:

Then execute the `install.sh` script to install everything you need. You may need `sudo` permissions.

```sh
# In your .dotfiles directory
./install.sh
```

## Roadmap

- [ ] One-touch deployment on Linux (Ubuntu | Fedora | Arch)
- [ ] Automatic key-remapping for Linux and macOS
