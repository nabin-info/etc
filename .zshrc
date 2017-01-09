##
## ZSH SHELL OPTIONS
##
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="C"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
unset LC_ALL

export TIME_STYLE="long-iso"
export TIME_SPEC="long-iso"

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt appendhistory 

nohist() {
  export HISTFILE=
  export HIST=
  echo 'history for this session will not be saved'
}

zstyle :compinstall filename '/home/rnabinger/.zshrc'
autoload -Uz compinit
compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 0 numeric
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

bindkey -e
unsetopt autocd 
unsetopt beep
setopt extendedglob
setopt nullglob
setopt notify

autoload -U run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-svk
unalias run-help 2>/dev/null
alias help='run-help'

precmd() { 
  print
  print -rP '%E%F{yellow}:%f %F{green}%n%F{cyan}@%M%f:%B%F{white}%//' 
}
PS1='%E%F{yellow}%B%#%b%f '

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

autoload -U select-word-style
select-word-style bash

##
## Environment
##
path-clean() {
  # removes duplicates from path
  local R=: local IFS=: local p=
  for p in ${=PATH} ; do
    [[ $R == *:$p:* ]] || R=$R$p:
  done
  R=${R##:}
  R=${R%%:}
  PATH=$R
}

export GOROOT="/usr/lib/go"
export GOPATH="${HOME}/go"
export PYTHONSTARTUP="${HOME}/.pyrc"

PATH="${HOME}/bin:${GOPATH}/bin:${PATH}"
path-clean
export PATH

alias use_mxe='export PATH=/opt/mxe/usr/bin:${PATH//\/opt\/mxe\/usr\/bin:/} ; rehash'
alias use_havana='. /opt/havana/bin/activate'
alias use_ptxdist='export PATH=${PATH}:/home/rnabinger/ptxdist/bin'

: ${ED:=$(which vim)}
: ${ED:=$(which vi)}
: ${EDITOR:=$ED}
: ${VISUAL:=$ED}

: ${PAGER:=$(which less)}
: ${PAGER:=$(which more)}
: ${PAGER:=$(which cat)}
: ${LESS:=-FgSXR}
export LESS="-FgSXRI"
: ${MORE:=-fud}
alias page=$PAGER


faketty() { script -qfc "$(printf "%q " "$@")"; }

alias resize_term='watch -n1 echo \$COLUMNS x \$LINES '

: ${BROWSER:=$(which chromium 2>/dev/null)}
: ${BROWSER:=$(which firefox  2>/dev/null)}
: ${BROWSER:=$(which links    2>/dev/null)}
: ${BROWSER:=$(which w3m      2>/dev/null)}

##
## Aliases
##
alias rerc='. ~/.zshrc'
alias virc='vim -o ~/.{zshrc,vimrc,xinitrc,aliases}'
[[ -r  ~/.aliases ]] && source ~/.aliases

  
## autostart Xorg depending on tty
if [ x$(tty) = x/dev/tty1 ] 
then
  export WMNAME=awesome
  exec startx
fi
