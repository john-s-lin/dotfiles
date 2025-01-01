# Steps

Note this is for a headless installation and access through `ssh`. Not for desktop yet.

1. Flash SD card using `balenaetcher` and the most recent version of `dietpi`
2. (Optional) Configure automated wifi network before first boot
   > Only do this if you're not connecting it through ethernet
3. Copy the configuration from `dietpi-example.txt` for automated headless setup.
4. Install packages using `dietpi-software` command.
   1. `zsh`
   2. `git`
   3. `OpenSSH`
   4. (Optional) `Dietpi Dashboard`
   5. `pihole`
   6. `Docker`
   7. `Docker-Compose`
   8. (Optional) `Tailscale` for `actual-budget`. See [Actual Budget Setup](../actual_budget_setup.md).
5. Clone `.dotfiles` with `https`
6. Run `install.sh` as `dietpi`
7. `chsh -s $(which zsh)` to set the default `$SHELL=zsh`
8. `cp .gitconfig.local` from a different computer
9. Setup `.ssh` for GitHub
10. Replace `.dotfiles` remote url with the `ssh` version

```bash
git remote set-url origin <URL>
```

# Installing packages from source

> Note: In the future, just install neovim from source using the build instructions in the wiki and don't do it this way.

- `neovim` (built from `GitHub` using binary since `apt` doesn't have 0.8+)
  - Ref: https://luther.io/articles/how-to-install-neovim-on-raspberry-pi/
  - Requires:
  - `git`
  - `clang`
    > Note: Do not use `gcc`, because the linker doesn't work on `arm`
  - `file`
  - `gettext`
  - `make`
  - `cmake`

# Roadmap

- [x] Configure a `.zshrc` for Linux
- [x] Configure a `.bashrc` for Linux
- [x] `pi.hole` install
- [x] `miniconda`
- [x] Write a `install.sh` for Linux in `.dotfiles`
