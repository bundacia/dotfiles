function parse_git_branch {
  BRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
  if [ "$BRANCH" != "" ]; then
      echo " $BRANCH";
  else
      echo '';
  fi
   
}

#export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w$(parse_git_branch) \$\[\033[00m\] '
export PS1='\[\033[0;33m\]\!:\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '

# for macports
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$PATH

export PATH=$HOME/bin:$PATH

export MT_CODEBASE=$HOME/mt.dev/public/MoneyTracker

export GOROOT=$HOME/go
export GOARCH=amd64
export GOOS=darwin

# Source in rvm methods
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

source ~/.alias
