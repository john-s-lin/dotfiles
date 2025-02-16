# Disable warning messages at the beginning since you're not admin
ZSH_DISABLE_COMPFIX="true"

# Get architecture and platform
arch=$(uname -m)
platform=$(uname -s)

# Function to add paths if not already in $PATH
add_to_path() {
  if [[ -n "$1" && ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# Change variables depending on architecture and OS type
if [[ "$platform" == "Darwin" ]]; then
  if [[ "$arch" =~ "arm"* ]]; then
    brew_path="/opt/homebrew/bin"
    brew_opt_path="/opt/homebrew/opt"
  elif [[ "$arch" =~ "x86"* ]]; then
    brew_path="/usr/local/bin"
    brew_opt_path="/usr/local/opt"
  fi
fi

# Set docker bin path
local docker_path="$HOME/.docker/bin"

# Set rust bin path if exists
if [ -d "$HOME/.cargo" ]; then
  local rust_path="$HOME/.cargo/bin"
else
  local rust_path=""
fi

# Set java path if exists
if command -v java &>/dev/null && java --version 2>&1 | grep -q "openjdk"; then
  local java_path="${brew_opt_path}/openjdk/bin"
else
  local java_path=""
fi

# Set GOPATH if exists
if command -v go &>/dev/null; then
  export GOPATH="${HOME}/.go"
  local go_path=$(go env GOPATH)/bin
else
  local go_path=""
fi

# Add paths to PATH without duplicates
add_to_path "${brew_path}"
add_to_path "${java_path}"
add_to_path "${docker_path}"
add_to_path "${go_path}"
add_to_path "${rust_path}"
add_to_path "/usr/local/bin"
add_to_path "/usr/local/sbin"

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# If you have starship, don't set the theme, else set it to custom robbyrussell
# because it shows you the hostname in the prompt
ZSH_THEME="robbyrussell"

# fnm
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# Export ENV CONFIG
export CONFIG_HOME="${HOME}/.config"

# ohmyzsh plugins and config
plugins=(git vi-mode zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Aliases
if [ -e "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

# Fuzzy finder
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  export _ZO_DATA_DIR="${HOME}/.local/share/zoxide"
  eval "$(zoxide init --cmd cd zsh)"
fi

# Starship
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
  export STARSHIP_CACHE="${HOME}/.starship/cache"
  ZSH_THEME=""
  eval "$(starship init zsh)"
fi
