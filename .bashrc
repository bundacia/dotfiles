#export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w$(parse_git_branch) \$\[\033[00m\] '
#export PS1='\[\033[0;33m\]\!:\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
export PS1='\[\033[0;33m\]\!:\[\033[1;35m\]\u@\h\[\033[0;34m\] \w \$\[\033[00m\] '

# look in /usr/local first (macports, anything manually compiled)
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$PATH

export PATH=$HOME/bin:$PATH

export EDITOR=/usr/bin/vim

# Source in rvm methods
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# colorize ls
alias ls='ls -G'
source ~/.alias
