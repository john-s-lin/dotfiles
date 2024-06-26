# Disable warning messages at the beginning since you're not admin
ZSH_DISABLE_COMPFIX="true"

# Get architecture
arch=$(uname -m)

# Change variables depending on architecture
if [[ $arch =~ arm* ]]; then
    brew_path="/opt/homebrew/bin"
    brew_opt_path="/opt/homebrew/opt"
    brew_conda_path="/opt/homebrew"
elif [[ $arch =~ x86* ]]; then
    brew_path="/usr/local/bin"
    brew_opt_path="/usr/local/opt"
    brew_conda_path="/usr/local"
fi

# Set nvm path
local nvm_path="$HOME/.nvm"

# Set docker bin path
local docker_path="$HOME/.docker/bin"

# Set rust bin path if exists
if [ -d "$HOME/.cargo" ]; then
    local rust_path="$HOME/.cargo/bin"
else
    local rust_path=""
fi

# Set java path if exists
if command -v java &> /dev/null && java --version 2>&1 | grep -q "openjdk"; then
    local java_path="${brew_opt_path}/openjdk/bin"
else
    local java_path=""
fi

# Set GOPATH if exists
if command -v go &> /dev/null; then
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

export NVM_DIR="${nvm_path}"

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="passion"
if [[ "${ZSH_THEME}" == "passion" && -x "$(command -v conda)" ]]; then
  conda config --set changeps1 False
else
  conda config --set changeps1 True
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git nvm zsh-autosuggestions zsh-syntax-highlighting)

zstyle ':omz:alpha:lib:git' async-prompt no
zstyle ':omz:plugins:nvm' lazy yes
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
#alias zshconfig="nvim ~/.zshrc"
#alias ohmyzsh="code ~/.oh-my-zsh"
if [ -e "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide
eval "$(zoxide init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(${brew_conda_path}/Caskroom/miniconda/base/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${brew_conda_path}/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "${brew_conda_path}/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="${brew_conda_path}/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
