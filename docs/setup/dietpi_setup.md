# Steps
Note this is for a headless installation and access through `ssh`. Not for desktop yet.

1. Flash SD card using `balenaetcher` and the most recent version of `dietpi`
2. (Optional) Configure automated wifi network before first boot
   >Only do this if you're not connecting it through ethernet
3. Install packages using built-in `dietpi-software`
	1. `git`
	2. `OpenSSH`
	3. (Optional) `Dietpi Dashboard`
4. Setup `gitconfig` and `.gitconfig.local`
5. Clone `.dotfiles`

# Installed packages
- `tmux`
- `neovim` (built from `GitHub` using binary since `apt` doesn't have 0.8+)
- `zsh`
- `oh-my-zsh`
	- `Passion` theme
	- `zsh-autosuggestions`
	- `zsh-syntax-highlighting`
- `oh-my-bash`
	- `Pure` theme

# Roadmap
- [ ] Configure a `.zshrc` for Linux
- [ ] Configure a `.bashrc` for Linux
- [x] `pi.hole` install
- [x] `miniconda`
- [ ] Write a `install.sh` for Linux in `.dotfiles`