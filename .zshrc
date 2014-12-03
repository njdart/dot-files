#!/bin/bash
# External sources
if [ -e /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsH	# zsh syntax highlighting
											# install zsh-colour-highlighting
else 
    source ./zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob HIST_IGNORE_DUPS
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nic/.zshrc'

autoload -Uz compinit
autoload -U colors; colors
compinit
# End of lines added by compinstall

export PATH=$PATH:/home/nic/bin/

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
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

PROMPT="[%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m(%l)%{$reset_color%}] %{$fg_no_bold[yellow]%}%~ %{$reset_color%}%# "
RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}] [%{$fg[magenta]%}%T %D%{$reset_color%}]"

alias ls='ls -sh1 --color'
alias hal='ls -halp'
alias grep='grep --color'
alias egrep='grep -E -o --color'
alias pingg="ping www.google.co.uk"
