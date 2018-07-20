# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    pathadd "$HOME/bin"
fi

# Set CLICOLOR if you want Ansi Colors in iTerm2 
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# paths
pathadd /Users/shibo/scripts
export GOPATH=/Users/shibo/Code/go
pathadd "$GOPATH/bin"

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
alias gm='git merge'
alias gmf='git merge --no-ff'
alias gms='git merge --squash'
alias ga='git add'
alias gr='git reset'
alias grh='git reset --hard'
alias gst='git stash'
alias gsta='git stash apply'
alias memcached-restart="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist;launchctl load ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"


# init pyenv
eval "$(pyenv init -)"
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# init nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
pathadd "$(npm bin -g)"

export GPG_TTY=$(tty)

