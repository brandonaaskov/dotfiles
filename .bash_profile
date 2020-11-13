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
