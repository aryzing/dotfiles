# welcome
echo Welcome $USER! On $HOSTNAME.
date +"%d-%m-%Y, %H:%m"
echo

# aliases for quick directories
alias blyp='cd ~/hr/coursework/sprints/thesis/blyp'
alias toy='cd ~/hr/coursework/toy/'
alias play='cd ~/workspace/playground'
alias notes='cd ~/workspace/notes'
alias ary='cd ~/workspace/aryzing.net'
alias aryzing='cd ~/workspace/aryzing.net'
mkcdir() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

# necessary for nvm and node to run
# see https://github.com/creationix/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
