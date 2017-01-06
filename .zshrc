#!/bin/bash
# External sources
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh	# zsh syntax highlighting
											# install zsh-colour-highlighting

source /usr/share/doc/pkgfile/command-not-found.zsh					# sudo pacman -S pkgfile
# Lines configured by zsh-newuser-install
HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob HIST_IGNORE_DUPS
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nic/.zshrc'

autoload -Uz compinit compdef
autoload -U colors; colors
compinit
# End of lines added by compinstall

export PATH=$PATH:$HOME/bin/:/home/nic/.gem/ruby/2.3.0/bin:$HOME/.cabal/bin
export TERM=xterm
export COLORTERM=urxvt
export EDITOR="/usr/bin/vim"
export BROWSER="/usr/bin/google-chrome-stable"
export GOPATH="/home/nic/go"
#export JAVA_HOME="/usr/lib/jvm/java-7-openjdk/bin/java"
#export IDEA_JDK=$JAVA_HOME
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/cuda/lib64"
export CUDA_HOME=/opt/cuda/

# key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
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

PROMPT="[%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m(%l)%{$reset_color%}] %{$fg_no_bold[yellow]%}%~ %{$reset_color%}%# "
#RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}] [%{$fg[magenta]%}%T %D%{$reset_color%}]"

# Stop Ctl+S
stty -ixon

alias ls='ls -sh1 --color'
alias hal='ls -halp'
alias grep='grep --color'
alias egrep='grep -E --color'
alias pingg="ping www.google.co.uk"
alias spammers="sudo cat /var/log/fail2ban.log | egrep 'Ban.+' | awk '{print $2}' > /tmp/spammers; sort /tmp/spammers | uniq | xargs -I % curl -silent http://www.whois.com/whois/% | egrep 'country:\s*..' > ~/spammers"
alias l="ls"
alias lock='dm-tool lock'
alias scrot='scrot ~/screenshots/%Y-%m-%d-%T-screenshot.png -e '"'"'echo $f'"'"
alias less="less -R"
alias more="less"
source /usr/share/nvm/init-nvm.sh

markdown-gen () {
  /usr/bin/markdown $1 > $1.html && $BROWSER $1.html
}
