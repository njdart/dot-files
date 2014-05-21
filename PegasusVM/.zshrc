# Lines configured by zsh-newuser-install
HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nic/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ls='ls -sh1 --color'
alias hal='ls -hal'
alias grep='grep --color'
alias egrep='grep -E -o --color'
