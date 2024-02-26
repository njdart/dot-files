#!/bin/bash

HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory autocd extendedglob HIST_IGNORE_DUPS

autoload -Uz compinit compdef
autoload -Uz vcs_info
autoload -U colors

##
## Options from https://zsh.sourceforge.io/Doc/Release/Options.html#Options
##
set -o autopushd # cd acts as pushd, popd to reverse
set -o pushdignoredups # Ignore duplicates in history file
set -o append_history # Append to history for each new terminal, allows multiple vttys
set -o extended_history # Include timestamps and duration info # ‘: <beginning time>:<elapsed seconds>;<command>’
set -o hist_ignore_space # Ignore commands prefixed with space
set -o interactive_comments
set -o prompt_subst
## Prevent pipe from overwriting existing files, eg
# touch foo && echo "bar" > ./foo # zsh: file exists: ./foo
## Use echo "bar" >| ./foo to allow overwrite
set -o noclobber

colors
compinit
# Stop Ctl+S from freezing terminal
stty -ixon

# Set Prompt
if [ -f /.dockerenv || -f /run/secrets/kubernetes.io/serviceaccount/token ]; then
  PS1="[%{$fg[red]%}%n%{$reset_color%}@%{$fg[magenta]%}%m%{$reset_color%}] %{$fg_no_bold[yellow]%}%~%{$reset_color%}%\\$ "
else
  PS1="[%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}] %{$fg_no_bold[yellow]%}%~%{$reset_color%}%\\$ "
fi
RPS1='${vcs_info_msg_0_}'

export TERM=xterm
export COLORTERM=terminator
export EDITOR="/usr/bin/nvim"
export BROWSER="/usr/bin/firefox"
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,*.swp,dist,*.coffee}/*" 2> /dev/null'
export FZF_ALT_C_COMMAND="bfs -type d -nohidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--reverse --ansi --multi'
export HISTORY_IGNORE="(ls*|hal*|cd*|pwd*|exit*|poweroff*|reboot*|[ \t]*|pass*)"
export ANDROID_HOME=/opt/Android/sdk
export ANDROID_SDK_ROOT=/opt/Android/sdk
export PATH=$HOME/bin:$ANDROID_HOME/build-tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$HOME/.gem/ruby/2.6.0/bin:$HOME/.local/bin:$GOBIN:$PATH
export PASSWORD_STORE_GENERATED_LENGTH=32
export KUBECTL_DEBUG_IMAGE=registry.gitlab.com/njdart/dot-files:latest

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

alias ls='ls -sh1v --color'
alias hal='ls -hAlp --group-directories-first'
alias grep='grep -n --color=always'
alias egrep='grep -E --color=always'
alias pingg="ping www.google.com.au"
alias lock='dm-tool lock'
alias scrot='scrot ~/screenshots/%Y-%m-%d-%T-screenshot.png -e '"'"'xclip -selection c -t image/png < $f && echo $f coppied to clipboard'"'"
alias less="less -R"
alias vim="nvim"
alias diff='diff --color=always'
alias gitc='git log --color=always --format="%C(auto)%h %<(15,trunc)%an %s %C(black)%C(bold)%cr %C(auto)%d" | fzf | awk '"'"'{print $1}'"'"
alias gitvc='git show `gitc` --color | less'
alias gitt="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias mpw="mpv --x11-name=docked"
alias date="date --utc --iso-8601=s"
alias kubectl-debug='kubectl run $(whoami)-debug --rm=true --restart=Never --image=$KUBECTL_DEBUG_IMAGE --stdin=true --tty=true'

# Styling
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '*'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{$fg[blue]%}%b%{$reset_color%}:%{$fg[red]%}(%m%u%c)%{$reset_color%}"

function precmd {
  vcs_info
}

# Source external dependencies
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh
[ -f ~/.config/`hostname`.zshrc ] && source ~/.config/`hostname`.zshrc

