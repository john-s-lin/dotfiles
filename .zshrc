# Disable warning messages at the beginning since you're not admin
ZSH_DISABLE_COMPFIX="true"

# Get architecture and platform
arch=$(uname -m)
platform=$(uname -s)

# Change variables depending on architecture and OS type
if [[ "$platform" == "Darwin" ]]; then
  if [[ "$arch" =~ "arm"* ]]; then
    brew_path="/opt/homebrew/bin"
    brew_opt_path="/opt/homebrew/opt"
    conda_path="/opt/homebrew/Caskroom/miniconda/base"
  elif [[ "$arch" =~ "x86"* ]]; then
    brew_path="/usr/local/bin"
    brew_opt_path="/usr/local/opt"
    conda_path="/usr/local/Caskroom/miniconda/base"
  fi
elif [[ "$platform" =~ "Linux" ]]; then
  if [[ -d "${HOME}/.miniconda3" ]]; then
    conda_path="${HOME}/.miniconda3"
  elif [[ -d "${HOME}/.miniforge3" ]]; then
    conda_path="${HOME}/.miniforge3"
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

# If you come from bash you might have to change your $PATH.
export PATH="${HOME}/bin:\
${brew_path}:\
${java_path}:\
${docker_path}:\
${go_path}:\
${rust_path}:\
/usr/local/bin:\
/usr/local/sbin:\
${PATH}"

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="passion"
if [[ -x "$(command -v conda)" ]]; then
  if [[ "${ZSH_THEME}" == "passion" ]]; then
    conda config --set changeps1 False
  else
    conda config --set changeps1 True
  fi
fi

# fnm
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# Export ENV CONFIG
export CONFIG_HOME="${HOME}/.config"

# ohmyzsh plugins and config
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
zstyle ':omz:alpha:lib:git' async-prompt no
source $ZSH/oh-my-zsh.sh

# Aliases
if [ -e "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

# Fuzzy finder
[ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(${conda_path}/bin/conda 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "${conda_path}/etc/profile.d/conda.sh" ]; then
    . "${conda_path}/etc/profile.d/conda.sh"
  else
    export PATH="${conda_path}/bin:$PATH"
  fi
fi
unset __conda_setup
# <<< conda initialize <<<
