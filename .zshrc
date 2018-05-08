#!/bin/bash

HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory autocd extendedglob HIST_IGNORE_DUPS

# Source external dependencies
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh
[ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh
[ -f $HOME/.config/`hostname`.zshrc ] && source $HOME/.config/`hostname`.zshrc
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

autoload -Uz compinit compdef
autoload -Uz vcs_info
autoload -U colors
setopt prompt_subst

colors
compinit
# Stop Ctl+S from freezing terminal
stty -ixon

# Set Prompt
PS1="[%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}] %{$fg_no_bold[yellow]%}%~%{$reset_color%}%\\$ "
RPS1='${vcs_info_msg_0_}'

export TERM=xterm
export COLORTERM=terminator
export EDITOR="/usr/bin/nvim"
export BROWSER="/usr/bin/google-chrome-stable"
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export FZF_DEFAULT_OPTS="--reverse --ansi --multi"
export HISTORY_IGNORE="(ls*|cd*|pwd*|exit*|[ \t]*)"
export PATH=$HOME/bin:/.gem/ruby/2.3.0/bin:$HOME/.local/bin:$HOME/.cabal/bin:$PATH:$GOBIN

# key bindings
#bindkey -e
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey "^H" backward-delete-word
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/mebian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

alias ls='ls -sh1 --color'
alias hal='ls -hAlp --group-directories-first'
alias grep='grep -n --color=always'
alias egrep='grep -E --color=always'
alias pingg="ping www.google.co.uk"
alias lock='dm-tool lock'
alias scrot='scrot ~/screenshots/%Y-%m-%d-%T-screenshot.png -e '"'"'echo $f'"'"
alias less="less -R"
alias vim="nvim"
alias diff='diff --color=always'
alias gitc='git log --color=always --format="%C(auto)%h %<(15,trunc)%an %s %C(black)%C(bold)%cr %C(auto)%d" | fzf | awk '"'"'{print $1}'"'"
alias gitvc='git show `gitc` --color | less -R'
alias gitt="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Styling
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '*'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{$fg[blue]%}%b%{$reset_color%}:%{$fg[red]%}(%m%u%c)%{$reset_color%}"

function minikube {
  if [ "$(kubectl config current-context)" == 'minikube' ]; then
    /usr/bin/minikube $@
  else
    echo "Kubectl context is not minikube. Refusing to work"
    return 1
  fi
}

function precmd {
  vcs_info
}
