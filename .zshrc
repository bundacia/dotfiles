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
    git diff $(git merge-base ${1:-HEAD} ${2:-master}) ${1:-HEAD}
}

git-branch-difftool() {
    git difftool $(git merge-base ${1:-HEAD} ${2:-master}) ${1:-HEAD}
}

git-branch-st() {
    git diff --name-only $(git merge-base ${1:-HEAD} ${2:-master}) ${1:-HEAD}
}

push_branch() {
    git push -u origin $1
}

git_origin_owner() {
    git remote -v|grep origin|head -n1|cut -d':' -f2|cut -d' ' -f1|cut -d/ -f1
}

git_origin_repo(){
    git remote -v|grep origin|head -n1|cut -d':' -f2|cut -d' ' -f1|cut -d/ -f2|cut -d'.' -f1
}

export API_ROOT=http://code.livingsocial.net/api/v3/repos

add_fork() {
    # Abort if the "fork" remote already exists
    git remote|grep -q fork && echo "'fork' remote already exists" && return

    curl -X POST "$API_ROOT/$(git_origin_owner)/$(git_origin_repo)/forks" -u "$GHE_API_TOKEN:x-oauth-basic"

    FORK_REMOTE="git@code.livingsocial.net:tlittle/$(git_origin_repo)"
    git remote add fork $FORK_REMOTE
}

parse_pr_json() {
    egrep '"title"|"number"' |\
    cut -d: -f2              |\
    perl -0 -e '$_ = <>; s/(\d+),\n\s+"(.*)",/PR $1: $2/g; print'
}

prs() {
    curl -s "$API_ROOT/$(git_origin_owner)/$(git_origin_repo)/pulls?state=open" -u "$GHE_API_TOKEN:x-oauth-basic" |parse_pr_json
}

make_ramdisk() {
    size_in_mb=${1:=100} # default to 100MB
    size_in_sectors=$(( $size_in_mb * 2048 ))
    export RAMDISK_DEVICE=`hdiutil attach -nomount ram://$size_in_sectors`
    diskutil erasevolume HFS+ 'RAM Disk' $RAMDISK_DEVICE
}

detach_ramdisk() {
    hdiutil detach $RAMDISK_DEVICE
}

ls-tmux() {
    tmux new-session -s ls -c ~/work
}

jira-create() {
    http --pretty=format POST https://$LS_JIRA_AUTH@jira.livingsocial.net/rest/api/2/issue/ \
        fields:='{ "summary": "'$1'", "description": "", "project": {"key": "CAT"}, "issuetype": {"name": "'${2-Task}'"} }' \
    | sed -n 's/ *"key": "\(.*\)",/https:\/\/jira.livingsocial.net\/browse\/\1/p'
}

PROMPT="%{$fg_bold[magenta]%}{%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%} %{$fg_bold[magenta]%}}%{$reset_color%}
%{$fg[blue]%}%#%{$reset_color%} "

bindkey -e # Use emacs mode

setopt append_history hist_ignore_dups hist_ignore_space hist_no_store hist_verify
setopt correct # correct misspelled commands
setopt nullglob
setopt interactivecomments # allow comments on the command line

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
PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH

PATH=/usr/local/Cellar/mysql55/5.5.44/bin:$PATH

# add bin from homedir
PATH=$HOME/bin:$PATH
PATH=$HOME/bin.private:$PATH

# add LG bin
PATH=$HOME/lg/bin:$PATH

# LivingSocial
DEALS_HIDE_AB_WARNING=1

unsetopt ALL_EXPORT

# Node Setup
export NODE_ENV=development

# hub: https://hub.github.com/
export GITHUB_HOST=code.livingsocial.net
export GITHUB_USER=tlittle

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

# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"

### Iterm Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

ulimit -n 65536 65536
