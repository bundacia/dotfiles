setopt ALL_EXPORT
HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
PAGER='less'
EDITOR=$(which vim)

# Turn on autocompletion
autoload -U compinit   && compinit
autoload -U promptinit && promptinit
autoload -U colors     && colors

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
        if [[ $git_status =~ "Changed but not updated" ]]; then
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
    RPROMPT="$(parse_git) - $(current_vpn)"
}

connect_to_vpn(){
    # create session if it doesn't already exist
    tmux new-session -d -s vpn >/dev/null 2>&1
    # send the command to stop the running vpn and start the new one
    tmux send-keys -tvpn:1 'C-C' " sudo openvpn --config $1" 'C-m'
    sleep 0.5 # give time to connect =)
}

current_vpn(){
    pgrep openvpn|xargs ps|sed -n 's/.*tlittle-\(.*\).ovpn/\1/p'
}

# show full history, with optional grep filter
h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

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

# look in /usr/local first (macports, anything manually compiled)
PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/mysql/bin:$PATH

# add bin from homedir
PATH=$HOME/bin:$PATH

unsetopt ALL_EXPORT

alias ls='ls -G'
source ~/.alias

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
