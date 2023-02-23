# .dotfiles

Main setup files for all programs on a new developer machine. `.zshrc` will work for `x86_64` and `arm64` Macs and can be ported without modification.

## Setup

Make sure `install.sh` is executable:

```sh
chmod u+x <path_to_install.sh>
```

Then execute the `install.sh` script to install everything you need. You may need `sudo` permissions.

```sh
# In your .dotfiles directory
./install.sh
```

## Roadmap

- Automatically symlink the config files from an executable script
- Automatically create the right config directory for nvim and symlink `init.lua`
- Figure out how to configure Mac settings from a config file or shell script

