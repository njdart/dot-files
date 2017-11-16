#!/bin/bash
# External sources
HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob HIST_IGNORE_DUPS
bindkey -e
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit compdef
autoload -Uz vcs_info
autoload -U colors; colors
compinit

export PATH=$HOME/bin:/.gem/ruby/2.3.0/bin:$HOME/.local/bin:$HOME/.cabal/bin:$PATH

export TERM=xterm
export COLORTERM=terminator
export EDITOR="/usr/bin/nvim"
export BROWSER="/usr/bin/google-chrome-stable"
export GOPATH="$HOME/go"
export FZF_DEFAULT_OPTS="--reverse --ansi --multi"

# key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey "^H" backward-delete-word
# for rxvt
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

# Stop Ctl+S
stty -ixon

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

# Git Alias
alias gitc='git log --color=always --format="%C(auto)%h %<(15,trunc)%an %s %C(black)%C(bold)%cr %C(auto)%d" | fzf | awk '"'"'{print $1}'"'"
alias gitt="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh
[ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh
[ -f $HOME/.config/`hostname`.zshrc ] && source $HOME/.config/`hostname`.zshrc
if [ -f /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi

# Styling
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%{$fg[blue]%}%b%{$reset_color%} "

precmd() {
    vcs_info
}

setopt prompt_subst

PROMPT='[%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m(%l)%{$reset_color%}] %{$fg_no_bold[yellow]%}%~%{$reset_color%} ${vcs_info_msg_0_}%# '

function minikube {
  if [ ! "$(kubectl config current-context)" == 'demo.ccl-flo.com' ]; then
    /usr/bin/minikube $@
  else
    echo "Kubectl context is not minikube. Refusing to work"
  fi
}

