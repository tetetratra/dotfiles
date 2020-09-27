# rbenv用
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

export PATH="/usr/local/Cellar/python/3.7.5/Frameworks/Python.framework/Versions/3.7/bin:$PATH"

##############
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="candy"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git zsh-syntax-highlighting zsh-completions)
# zsh-completionsの設定
autoload -U compinit && compinit -u

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#################
# alias
alias l='ls -AlFGhv'
alias ls='ls -AFGv'
alias ll='ls -AlFGhv'
alias tree='tree -a -C -I "\.DS_Store|\.git|node_modules|vendor\/bundle" -N'
alias g='git'
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I'
alias scselect='/usr/sbin/scselect'
alias p='pbpaste'
alias c='pbcopy'
alias o='open'
alias ber='bundle exec ruby'
alias be='bundle exec'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias rm='rmtrash'

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

cdls () {
  \cd "$@" && ls -AFGv
}
alias cd="cdls"

# ls color
export LSCOLORS=exfxcxdxbxbxHxHxHxGxGx

source ~/.export_keys.sh

######

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true #formats 設定項目で %c,%u が使用可
zstyle ':vcs_info:git:*' stagedstr "%F{green}!" #commit されていないファイルがある
zstyle ':vcs_info:git:*' unstagedstr "%F{magenta}+" #add されていないファイルがある
zstyle ':vcs_info:*' formats "%F{cyan}%c%u(%b)%f" #通常
zstyle ':vcs_info:*' actionformats '[%b|%a]' #rebase 途中,merge コンフリクト等 formats 外の表示
precmd () { vcs_info }
PROMPT='%{$fg[red]%}[%n@%m]%{$reset_color%}'
PROMPT=$PROMPT'${vcs_info_msg_0_} %{${fg[red]}%}%}$%{${reset_color}%} '

PROMPT=$'\n%{$fg[blue]%}%~%{$reset_color%} ${vcs_info_msg_0_}\n%{$fg[red]%}> %{$reset_color%}'
#RPROMPT='%{${fg[green]}%}[%t]%{${reset_color}%}'

# 大文字小文字に関わらず, 候補が見つからない時のみ文字種を無視した補完をする
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# [zshの補完候補にls --colorsと同じ色をつける](https://gist.github.com/mmasaki/9523518)
autoload colors
colors
autoload -U compinit
compinit
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=01;34:su=41;30:sg=46;30:tw=42;30:ow=01;36'
zstyle ':completion:*' list-colors "${LS_COLORS}" # 補完候補のカラー表示



# vimmode入力
# set -o vi

# 現在はノーマルモードかインサートモードかを判断できるようプロンプトに表示
# function zle-line-init zle-keymap-select {
#     VIM_NORMAL="%K{208}%F{black}%k%f%K{208}%F{white} % NORMAL %k%f%K{black}%F{208}%k%f"
#     VIM_INSERT="%K{075}%F{black}%k%f%K{075}%F{white} % INSERT %k%f%K{black}%F{075}%k%f"
#     RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
#     RPS2=$RPS1
#     zle reset-prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select
#
# # jjでesc
# bindkey -M viins 'jj' vi-cmd-mode

# コマンド提案
setopt correct

# pure
fpath+=("$HOME/.zsh/pure")
autoload -U promptinit; promptinit
prompt pure

# crtstal
export PATH="$HOME/.crenv/bin:$PATH"
eval "$(crenv init -)"

# npm https://qiita.com/PolarBear/items/62c0416492810b7ecf7c
export PATH=$PATH:$HOME/.nodebrew/current/bin

# ctags用 https://qiita.com/maeharin/items/9f98c0d63ab764ee21a8
alias ctags="`brew --prefix`/bin/ctags"

# Hyper用。
export LANG=ja_JP.UTF-8


alias python="python3"
export PATH="$HOME/Library/Python/3.7/bin:$PATH"

# brewで入れた方をmac内蔵より優先度高く探す
export PATH=/usr/local/bin:$PATH

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

alias mvim='/Applications/MacVim.app/Contents/bin/mvim'
alias mvimr="mvim --remote-silent"
alias nvimr=nvr

# pyenv用
export PATH="$HOME/.pyenv/shims:$PATH"
eval "$(pyenv init -)"

# goのコマンドのインストール先
export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"


alias matlab_r='/Applications/MATLAB_R2020a.app/bin/matlab -nodisplay -nosplash -r '

# brew install 時にupdateを自動でしない(手動で定期的にbrew updateする必要あり)
export HOMEBREW_NO_AUTO_UPDATE=1
