setopt ALL_EXPORT
HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
PAGER='less'
EDITOR=$(which vim)

# Tuning for Ruby 2.1.2
RUBY_GC_HEAP_INIT_SLOTS=600000
RUBY_GC_HEAP_FREE_SLOTS=600000
RUBY_GC_HEAP_GROWTH_FACTOR=1.25
RUBY_GC_HEAP_GROWTH_MAX_SLOTS=300000
RUBY_GC_MALLOC_LIMIT=64000000
RUBY_GC_OLDMALLOC_LIMIT=64000000

# Turn on autocompletion
autoload -U compinit   && compinit
autoload -U promptinit && promptinit
autoload -U colors     && colors

os='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    os='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    os='osx'
fi

parse_git_branch () {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "${ref#refs/heads/}"
}

parse_git() {
    local branch=$(parse_git_branch)
    if [[ -z $branch ]]; then
        return
    #elif [[ $branch == 'master' ]]; then
    #    branch=''
    else
        branch="%{$fg[yellow]%}$branch%{$reset_color%}"
    fi


    local forward="↟"
    local behind="↡"
    local dot="•"

    local remote_pattern_ahead="# Your branch is ahead of"
    local remote_pattern_behind="# Your branch is behind"
    local remote_pattern_diverge="# Your branch and (.*) have diverged"

    local git_status="$(git status 2>/dev/null)"

    local state=""
    if [[ $git_status =~ "working directory clean" ]]; then
        state=""
    else
        if [[ $git_status =~ "Untracked files" ]]; then
            state="%{$fg[red]%}${dot}%{$reset_color%}"
        fi
        if [[ $git_status =~ "Changes not staged for commit" ]]; then
            state="${state}%{$fg[yellow]%}${dot}%{$reset_color%}"
        fi
        if [[ $git_status =~ "Changes to be committed" ]]; then
            state="${state}%{$fg[green]%}${dot}%{$reset_color%}"
        fi
    fi

    local direction=""
    if [[ $git_status =~ $remote_pattern_ahead ]]; then
        direction="%{$fg[green]%}${forward}%{$reset_color%}"
    elif [[ $git_status =~ $remote_pattern_behind ]]; then
        direction="%{$fg[red]%}${behind}%{$reset_color%}"
    elif [[ $git_status =~ $remote_pattern_diverge ]]; then
        direction="%{$fg[red]%}${forward}%{$reset_color%}%{$fg[red]%}${behind}%{$reset_color%}"
    fi

    local git_bit="[%{$reset_color%}${branch}${state}${git_bit}${direction}]"

    printf "%s" "$git_bit"
}

precmd () {
    RPROMPT="$(parse_git)"
}

# show full history, with optional grep filter
h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

start-ssh-agent() {
    stop-ssh-agent > /dev/null 2>&1
    eval `ssh-agent`
    ssh-add  -t $(( 60 * 60 * 8 )) ~/.ssh/{dw_id_dsa,id_rsa,qa_deployment_key,uat_deployment_key}
}

stop-ssh-agent() {
    eval `ssh-agent -k`
}

git-branch-diff() {
    git diff $(git merge-base ${1:-HEAD} ${2:-develop}) ${1:-HEAD}
}

git-branch-difftool() {
    git difftool $(git merge-base ${1:-HEAD} ${2:-develop}) ${1:-HEAD}
}

push_branch() {
    git push -u origin NEXT-$1:NEXT-$1
}

PROMPT="%{$fg_bold[magenta]%}%n@%m%{$reset_color%} %{$fg[yellow]%}%20<..<%~ %{$reset_color%}%{$fg[blue]%}%#%{$reset_color%} "

bindkey -e # Use emacs mode

setopt append_history hist_ignore_dups hist_ignore_space hist_no_store hist_verify
setopt correct # correct misspelled commands
setopt nullglob

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Make the delete key work 
bindkey '^[[3~' delete-char

# \C-x\C-e to open an editor to edit the current line (fc will open the previous)
# this mimics the bash behavior
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

# look in /usr/local first (macports, anything manually compiled)
PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/mysql/bin:$PATH

# add bin from homedir
PATH=$HOME/bin:$PATH

unsetopt ALL_EXPORT

alias ls='ls -G'

if [[ -a ~/.alias ]]; then
    source ~/.alias
fi

if [[ -a ~/.zsh_private ]]; then
    source ~/.zsh_private
fi

if [[ -a /etc/zsh_command_not_found ]]; then
    source /etc/zsh_command_not_found
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
