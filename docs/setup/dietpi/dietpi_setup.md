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
   8. (Optional) `Tailscale`
5. Clone `.dotfiles` with `https`
6. Run `install.sh` as `dietpi`
7. `chsh -s $(which zsh)` to set the default `$SHELL=zsh`
8. `cp .gitconfig.local` from a different computer

# Installed packages

- `neovim` (built from `GitHub` using binary since `apt` doesn't have 0.8+)
- `oh-my-zsh`
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`

# Roadmap

- [x] Configure a `.zshrc` for Linux
- [x] Configure a `.bashrc` for Linux
- [x] `pi.hole` install
- [x] `miniconda`
- [x] Write a `install.sh` for Linux in `.dotfiles`
