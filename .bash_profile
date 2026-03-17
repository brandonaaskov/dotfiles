#!/usr/bin/env bash

source ~/.git-completion.bash

export EDITOR='vim'
export GOOGLE_APPLICATION_CREDENTIALS="~/.google/speech-to-text.json"

################################################ $PATH your ass off
export PATH="/usr/local/bin:$PATH"

# java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home

export FFMPEG_PATH="/usr/local/bin/ffmpeg"
export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:$PATH"
################################################


################################################ git love
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

COLOR_NC='\e[0m' # No Color
COLOR_WHITE='\e[1;37m'
COLOR_BLACK='\e[0;30m'
COLOR_BLUE='\e[0;34m'
COLOR_LIGHT_BLUE='\e[1;34m'
COLOR_GREEN='\e[0;32m'
COLOR_LIGHT_GREEN='\e[1;32m'
COLOR_CYAN='\e[0;36m'
COLOR_LIGHT_CYAN='\e[1;36m'
COLOR_RED='\e[0;31m'
COLOR_LIGHT_RED='\e[1;31m'
COLOR_PURPLE='\e[0;35m'
COLOR_LIGHT_PURPLE='\e[1;35m'
COLOR_BROWN='\e[0;33m'
COLOR_YELLOW='\e[1;33m'
COLOR_GRAY='\e[0;30m'
COLOR_LIGHT_GRAY='\e[0;37m'

# https://stackoverflow.com/questions/26229576/modify-bash-prompt-prefix-in-os-x-terminal
PS1="$COLOR_LIGHT_BLUE\W$COLOR_NC:$COLOR_YELLOW\$(parse_git_branch)$COLOR_NC\$ "
# PS1="$COLOR_GREEN\u@machine$COLOR_NC:\w$COLOR_YELLOW\$(parse_git_branch)$COLOR_NC\$ "
################################################



################################################ aliases
alias ll='ls -laG'
alias gs='git status -s'
alias gco='git checkout'
alias gcom='git checkout master'
alias gcod='git checkout develop'
alias gc='git commit -am'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias bail='git checkout HEAD -f'
alias cdd='cd ~/dev/rocketinsights/'
alias editbash="code ~/.bash_profile"
alias sourced="source ~/.bash_profile"
alias home="open ~"
alias here="open ."
alias server="python -m SimpleHTTPServer"
alias serve="python -m SimpleHTTPServer"
alias prune="git branch --merged | grep -v 'development$' | xargs git branch -d"
alias insecurechrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --disable-web-security --ignore-certificate-errors"
alias tower="gittower"
alias otg="ssh pi@raspberrypi.local"
alias retro="ssh pi@retropie.local"
# alias docker_prune="docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -aq)"
alias freshy="rm -rf node_modules && rm -rf .nuxt && rm -rf .next && yarn --production false"
alias ugh="rm yarn.lock && freshy && yarn dev"
alias ngrok=~/dev/.bin/ngrok
alias pgrestart="brew services restart postgresql"

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
  git branch | grep -v "master" | grep -v "development" | xargs git branch -D
}

function sha1 {
  echo -n "$1" | openssl sha1
}

function _mongod {
  mongod --config /usr/local/etc/mongod.conf --fork
}

function _redis {
  redis-server --daemonize yes # start as daemon
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
  # ffmpeg -i "$filename" -filter_complex "[0:v] fps=12,scale=960:-1:force_original_aspect_ratio=decrease" "${filenameSplit[0]}.gif"
  ffmpeg -i "$filename" -filter_complex "[0:v] fps=12,scale=iw:ih" "${filenameSplit[0]}.gif"
}

################################################
#                   PRO TIPS
################################################
# ------------------- HEROKU
# ----- Setup/Deploy App
# heroku create
# git push heroku master
# heroku ps:scale web=1
# heroku open

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# nvm (https://github.com/creationix/nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export YVM_DIR=/Users/brandonaaskov/.yvm
source /usr/local/bin/yvm

export YVM_DIR=/usr/local/opt/yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/brandonaaskov/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/brandonaaskov/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/brandonaaskov/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/brandonaaskov/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

. "$HOME/.cargo/env"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
. "/Users/brandonaaskov/.deno/env"
. "$HOME/.langflow/uv/env"
