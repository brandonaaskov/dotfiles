################################################ aliases
alias ll='ls -laG'
alias gs='git status -s'
alias gco='git checkout'
alias gcom='git checkout master'
alias gcod='git checkout develop'
alias gc='git commit -am'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias bail='git checkout HEAD -f'
alias prune="git branch --merged | grep -v 'development$' | xargs git branch -d"
alias freshy="rm -rf node_modules && rm -rf .nuxt && rm -rf .next && yarn --production false"

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

function killport () {
  lsof -nti:$1 | xargs kill -9
}
