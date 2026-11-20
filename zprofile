pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    pathadd "$HOME/bin"
fi
pathadd /opt/homebrew/bin
pathadd /usr/local/opt/tcl-tk/bin
pathadd $HOME/.local/bin
pathadd /opt/X11/bin

# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# Bash completion compat
autoload bashcompinit
bashcompinit

# paths
pathadd $HOME/scripts
export GOPATH=$HOME/Code/go
export GO111MODULE=auto
pathadd "$GOPATH/bin"
export CODE=$HOME/Code
export PY=$HOME/Code/python
export JS=$HOME/Code/js
export JAVA=$HOME/Code/java
export DEV=$HOME/Code/dev
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
alias gdh='git diff HEAD~ HEAD'
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
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

export GPG_TTY=$(tty)


eval $(/opt/homebrew/bin/brew shellenv)

# Created by `pipx` on 2025-03-06 17:41:21
export PATH="$PATH:$HOME/.local/bin"
