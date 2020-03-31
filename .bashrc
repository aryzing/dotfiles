# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### My Personal Additions ###

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "

# welcome
echo Welcome $USER! On $HOSTNAME.
date +"%Y-%m-%d, %H:%M"
echo

# aliases for quick directories
alias notes='cd ~/workspace/notes'
alias ary='cd ~/workspace/aryzing.net'
alias aryzing='cd ~/workspace/aryzing.net'
alias anccre='cd ~/workspace/anccre'
alias lal='ls -Al'
alias oos='code ~/workspace/oos-frontend-platforms'
alias bo='code ~/workspace/multitenancy-dashboard'
alias pipelines='code ~/workspace/concourse-build-pipelines'
alias releases='code ~/workspace/k8s-releases'
alias as='code ~/workspace/anccre-2-server'
alias ac='code ~/workspace/anccre-2-client'
alias redon='redshift -O 2700'
alias redoff='redshift -x'

mkcdir() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

# aliases for git
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
# alias go='git checkout ' # interferes with go programming langauge
function gacp() {
    git add .
    git commit -m "$1"
    git push
}

function lastTenTags() {
    if [[ $# -eq 0 ]] ; then
        echo 'You need to provide search text.'
        echo 'E.g., lastTenTagsOf root'
        exit 0
    fi
    git tag -l "**$1**" --sort=-version:refname | head -n 10
}

function deleteAllBranchesExceptMaster() {
    git checkout master
    git branch | grep -v '^*' | xargs git branch -d 
}
function deleteAllBranchesExceptMasterForce() {
    git checkout master
    git branch | grep -v '^*' | xargs git branch -D
}

function lastTenVersionsOf() {
    if [[ -z "$*" ]] ; then
        echo 'You need to provide search text.'
        echo 'E.g., `lastTenVersionsOf root`.'
        return
    fi
    git tag -l "**$1**" --sort=-version:refname | head -n 10
}

function oosTag() {
    if [ -z "$*" ] ; then
        echo 'You need to provide tag version and optional description.'
        echo 'E.g., `oosTag mfe-v1.2.3 "optional description"`.'
        return
    fi

    if [ -z "$2" ] ; then
        git tag -a "$1" -m "$1"
    else
        git tag -a "$1" -m "$2"
    fi

    git push origin "$1"
}

function setMasterToLatestOriginMaster() {
    git checkout -b tempBranch
    git fetch -q
    git br master origin/master -f
    git checkout master
    git br -D tempBranch
}

# set PATH to include rust cargo
export PATH="$HOME/.cargo/bin:$PATH"

# set PATH to include yarn bin
export PATH="$PATH:/home/aryzing/.yarn/bin"

# nvm - added automatically by nvm bash script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin

# 90POE stuff
export PATH=~/.local/bin:$PATH # this is for pip: https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html#install-linux-pip
function assume-role {
    for i in $(env | grep AWS | cut -d '=' -f 1); do
        unset $i;
    done
    eval $( $(which assume-role) -duration=12h $@);
}
alias kubetodev="hash -r && export KUBECONFIG=~/.kube/eduard_bardaji-dev.devopenocean.studio-admin.config && export K8S_CLUSTER='dev'"
alias kubetotest="hash -r && export KUBECONFIG=~/.kube/test.devopenocean.studio-admin.config && export K8S_CLUSTER='test'"
alias kubetodevnew="hash -r && export KUBECONFIG=~/.kube/new-dev-new.devopenocean.studio-admin.config && export K8S_CLUSTER='dev'"
alias kubetotestnew="hash -r && export KUBECONFIG=~/.kube/new-test-new.devopenocean.studio-admin.config && export K8S_CLUSTER='test'"
alias kubetostaging="hash -r && export KUBECONFIG=~/.kube/stg.devopenocean.studio-admin.config && export K8S_CLUSTER='stg'"
function k8sdev {
    kubetodev
    assume-role development
}
function k8stest {
    kubetotest
    assume-role test
}
function k8sdevnew {
    kubetodevnew
    assume-role dev-test
}
function k8stestnew {
    kubetotestnew
    assume-role dev-test
}
function k8sstg {
    kubetodev
    assume-role staging
}

PATH="$HOME/bin:${PATH}"
