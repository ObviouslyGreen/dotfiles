pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    pathadd "$HOME/bin"
fi
pathadd /usr/local/bin

# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# Bash completion compat
autoload bashcompinit
bashcompinit

# paths
pathadd /Users/shibo/scripts
export GOPATH=/Users/shibo/Code/go
# export GO111MODULE=on
pathadd "$GOPATH/bin"
export PY=/Users/shibo/Code/python
export JS=/Users/shibo/Code/js
export DEV=/Users/shibo/Code/dev
pathadd "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# aliases
alias c='clear'
alias gpp='git pull && git push'
alias gprp='git pull --rebase && git push'
alias gp='git push'
alias gpl='git pull'
alias gpr='git pull --rebase'
alias gpom='git pull origin master'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glp='gl -p'
alias gln='gl --name-only'
alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gcm='git commit -m '
alias gca='git commit --amend'
alias gd='git diff'
alias gds='git diff --staged'
alias gm='git merge'
alias gmf='git merge --no-ff'
alias gms='git merge --squash'
alias ga='git add'
alias gr='git reset'
alias grh='git reset --hard'
alias gst='git stash'
alias gsta='git stash apply'
alias gorigin='git remote show origin'
alias memcached-restart="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist;launchctl load ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"
alias agfzf='ag --nobreak --nonumbers --noheading . | fzf'

# init pyenv
eval "$(pyenv init -)"

# init nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
pathadd "$(npm bin -g)"

export GPG_TTY=$(tty)
