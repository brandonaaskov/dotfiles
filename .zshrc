# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/mainframelabs/.zsh/completions:"* ]]; then export FPATH="/Users/mainframelabs/.zsh/completions:$FPATH"; fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$(brew --prefix openvpn)/sbin:$PATH
export PATH=$HOME/.deno/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/mainframelabs/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

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

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
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
plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/.zshenv

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
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

################################################ aliases
alias ll='ls -laG'
alias gs='git status -s'
alias gco='git checkout'
alias gcom='git checkout master'
alias gcod='git checkout develop'
alias gc='git commit -am'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias bail='git checkout HEAD -f'
alias cdd='cd ~/dev/'
alias edit="code ~/.zshrc"
alias sourced="source ~/.zshrc"
alias home="open ~"
alias here="open ."
alias server="python3 -m http.server 9000"
alias serve="python3 -m http.server 9000"
alias prune="git branch --merged | grep -v 'development$' | xargs git branch -d"
alias insecurechrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --disable-web-security --ignore-certificate-errors"
alias tower="gittower"
alias otg="ssh pi@raspberrypi.local"
alias retro="ssh pi@retropie.local"
# alias docker_prune="docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -aq)"
alias freshy="rm -rf node_modules && rm -rf .nuxt && rm -rf .next && yarn --production false"
alias pgrestart="brew services restart postgresql"
alias kubectl="minikube kubectl --"
alias air='~/go/bin/air'
alias python="python3"
alias pip="pip3"
alias gpg2="gpg"
alias pyinit="python3 -m venv env && source env/bin/activate && pipreqs . --force && pip install -r requirements.txt"
alias venv="source env/bin/activate"
alias xsy="cd ~/dev/xsy-labs/"
alias app="cd ~/dev/xsy-labs/app.yieldpoint.io/"
alias api="cd ~/dev/xsy-labs/api.xsy.fi/"
alias index="cd ~/dev/xsy-labs/indexer-ponder/"
alias contract="cd ~/dev/xsy-labs/yieldpoint-contracts/"
alias update-claude="brew update && brew upgrade claude-code"
alias agent="cd ~/dev/agents/"
alias agents=agent


function gri() { # interactive rebase with the previous SHA
  git rebase -i $1^
}

function flushdns {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
  say "DNS cache flushed"
}

function docker_prune {
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
}

function git_prune {
  git branch | grep -v "master" | grep -v "main" | grep -v "production" | grep -v "staging" | grep -v "development" | xargs git branch -D
}

function sha1 {
  echo -n "$1" | openssl sha1
}

function sha256 { # pass in string with quotes. e.g. sha256 "this is a test"
  echo -n $1 | shasum -a 256 | awk '{ print $1 }'
}

function _mongod {
  mongod --config /usr/local/etc/mongod.conf --fork
}

function _redis {
  redis-server --daemonize yes # start as daemon
}

function use-qt5() {
  export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
  echo "Now using Qt 5"
}

function use-qt6() {
  # Reset PATH to original (this could be more sophisticated)
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  echo "Now using Qt 6"
}

findport () {
  lsof -i:$1
}

killport () {
  lsof -nti:$1 | xargs kill -9
}

makegif () {
  filename=$1
  IFS='.'; filenameSplit=($filename); unset IFS;
  ffmpeg -i "$filename" -filter_complex "[0:v] fps=12,scale=480:-1" "${filenameSplit[0]}.gif"
}

# removes all exif data from a given photo
exifwipe () {
  exiftool -all= -overwrite_original "$1"
}

exif () {
  exiftool "$1"
}

stl () {
  # find /Users/mainframelabs/dev/Adafruit_CAD_Parts -type f -name '*.stl' | grep -i "$1" | xargs -n 1 basename
  find /Users/mainframelabs/dev/Adafruit_CAD_Parts -type f -name '*.stl' -print0 | grep -iz "$1" | xargs -0 -n 1 basename
}

mcu() {
  # Find the most recently connected USB modem device
  DEVICE=$(ls -t /dev/tty.usbmodem* 2>/dev/null | head -n 1)

  if [ -z "$DEVICE" ]; then
    echo "No USB modem device found. Is your board connected?"
    return 1
  fi

  # Use provided baud rate or default to 115200
  BAUD=${1:-115200}

  echo "Connecting to $DEVICE at $BAUD baud..."
  screen $DEVICE $BAUD
}

pingloop() {
  while ! ping -c 1 -W 1 "$1" &>/dev/null; do
    echo "Waiting for $1..."
    sleep 1
  done
  echo "$1 is up!"
  ping "$1"
}

backup-dev() {
  local dest="/Volumes/dev/_Macbook Pro 2021"
  local devroot="$HOME/dev"

  # Check if we're inside ~/dev/
  if [[ "$PWD" != "$devroot"* ]]; then
    echo "Error: Not inside ~/dev/"
    echo "Current directory: $PWD"
    return 1
  fi

  # Get path relative to ~/dev/
  local relpath="${PWD#$devroot/}"

  # Check if NAS is mounted
  if [[ ! -d "$dest" ]]; then
    echo "Error: NAS not mounted at $dest"
    echo "Mount it in Finder first: afp://mainframe._afpovertcp._tcp.local/dev"
    return 1
  fi

  echo "Backing up '$relpath' to NAS..."

  rsync -rltvDP --checksum \
    --exclude 'node_modules' \
    --exclude 'dist' \
    --exclude 'build' \
    --exclude '__pycache__' \
    --exclude '.cache' \
    --exclude '*.pyc' \
    --exclude '.pio' \
    --exclude '.DS_Store' \
    "$PWD/" "$dest/$relpath/"

  echo "Backup complete: $dest/$relpath/"
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="/Users/mainframelabs/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mainframelabs/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mainframelabs/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mainframelabs/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mainframelabs/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
fpath=(/Users/mainframelabs/.local/share/zsh-completion/completions $fpath) # avalanche completion
rm -f ~/.zcompdump; compinit # avalanche completion


# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/mainframelabs/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP binary.
export PATH="/Users/mainframelabs/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/mainframelabs/Library/Application Support/Herd/config/php/84/"

# export NODE_EXTRA_CA_CERTS="/Users/mainframelabs/Library/Application Support/Herd/config/valet/CA/LaravelValetCASelfSigned.pem"
export PATH="/usr/local/opt/qt/bin:$PATH"
export PATH="/usr/local/opt/qt/bin:$PATH"
export PATH="/usr/local/opt/qt@5/bin:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:$PATH"
export BLINKA_U2IF="1"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# bun completions
[ -s "/Users/mainframelabs/.bun/_bun" ] && source "/Users/mainframelabs/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# export DO_NOT_TRACK=1
# export NODE_EXTRA_CA_CERTS="/System/Library/OpenSSL/certs/cert.pem"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Herd injected PHP 8.5 configuration.
export HERD_PHP_85_INI_SCAN_DIR="/Users/mainframelabs/Library/Application Support/Herd/config/php/85/"

# Added by Antigravity
export PATH="/Users/mainframelabs/.antigravity/antigravity/bin:$PATH"
export PATH="/opt/homebrew/opt/e2fsprogs/bin:$PATH"
export PATH="/opt/homebrew/opt/e2fsprogs/sbin:$PATH"
export PATH="$HOME/.foundry/bin:$PATH"
