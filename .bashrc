export PS1='\[\033[0;35m\]\u@\h\[\033[0;33m\] \w \$\[\033[00m\] '

export HISTCONTROL=ignorespace

# look in /usr/local first (macports, anything manually compiled)
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$PATH

export PATH=$HOME/bin:$PATH

export EDITOR=vim

# Source in rvm methods
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# colorize ls
alias ls='ls -G'
source ~/.alias
