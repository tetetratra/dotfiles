alias l='ls -AlFGhv'
alias ls='ls -AFGv'
alias ll='ls -AlFGhv'
alias tree='tree -a -C -I "\.DS_Store|\.git|node_modules|vendor\/bundle" -N'
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I'
alias scselect='/usr/sbin/scselect'
alias p='pbpaste'
alias c='pbcopy'
alias o='open'
alias nnn='tr "\n" " "'
alias ber='bundle exec ruby'
alias be='bundle exec'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias rm='trash'
alias mvim='/Applications/MacVim.app/Contents/bin/mvim'
alias dc='docker compose'
alias d='docker'

### 鍵 ###
source ~/.export_keys.sh

### zsh ###

# cdなしでディレクトリ名を直接指定して移動し、移動後自動でlsする https://qiita.com/puriketu99/items/e3c85fbe0fc4b939d0e2
setopt auto_cd
function chpwd() { ls }

# 大文字小文字に関わらず, 候補が見つからない時のみ文字種を無視した補完をする
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

autoload -U compinit; compinit # 補完機能を有効にする
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=01;34:su=41;30:sg=46;30:tw=42;30:ow=01;36'
zstyle ':completion:*' list-colors "${LS_COLORS}" # 補完候補のカラー表示

# コマンド提案
setopt correct

# pureプロンプト
fpath+=("$HOME/.zsh/pure")
autoload -U promptinit; promptinit
prompt pure

### 言語 ###

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# pyenv
export PATH="$HOME/.pyenv/shims:$PATH"
eval "$(pyenv init -)"

# npm https://qiita.com/PolarBear/items/62c0416492810b7ecf7c
export PATH=$PATH:$HOME/.nodebrew/current/bin

# go
export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"

### brew ###

# brewで入れた方をmac内蔵より優先度高く探す
export PATH=/usr/local/bin:$PATH
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# brew install 時にupdateを自動でしない (手動で定期的にbrew updateする必要あり)
export HOMEBREW_NO_AUTO_UPDATE=1

### key bind ###

bindkey -v # vim like
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins "^[[3~" backward-delete-char

function vi-yank-xclip { # https://stackoverflow.com/questions/61466461/yank-in-visual-vim-mode-in-zsh-does-not-copy-to-clipboard-in-ordert-to-paste-w
  zle vi-yank
  echo "$CUTBUFFER" | tr -d "\n" | pbcopy -i
}
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

disable r
export PATH="$HOME/bin:$PATH"
