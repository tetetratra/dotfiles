alias l='ls -AlFGhv'
alias ls='ls -AFGv'
alias ll='ls -AlFGhv'
alias tree='tree -a'
alias p='pbpaste'
alias c='pbcopy'
alias o='open'
alias ber='bundle exec ruby'
alias be='bundle exec'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias rm='trash'
alias d='docker'
alias dc='docker-compose'
alias dcr='(){  docker-compose run --rm $1 $2   -c "/bin/bash --rcfile <(echo \"alias r=ruby; alias be=\\\"bundle exec\\\"; alias lint=\\\"npx eslint --fix\\\"; alias l=\\\"ls -al\\\"; alias ll=\\\"ls -al\\\"; \")" }'
alias dcrb='(){ docker-compose run --rm $1 bash -c "/bin/bash --rcfile <(echo \"alias r=ruby; alias be=\\\"bundle exec\\\"; alias lint=\\\"npx eslint --fix\\\"; alias l=\\\"ls -al\\\"; alias ll=\\\"ls -al\\\"; \")" }'
alias nvim='nvim -p'
alias nvimp='nvim -p `pbpaste`'
alias tree='tree --charset unicode'
alias history='history -E 1'
# format
alias f="p | rr 'gsub(\".\", \".\n\n\").gsub(\"，\", \",\n\").gsub(\" \", \"\")' "

### 鍵 ###
if [ -e ~/.keys.sh ]; then
  source ~/.keys.sh
fi

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

# historyをuniq
setopt hist_ignore_dups
# 過去のものと同じなら古い方を削除
setopt hist_ignore_all_dups
# historyを共有
setopt share_history
# メモリに保存される履歴の件数
export HISTSIZE=10000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

### 言語 ###

# rbenv
if which rbenv > /dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# pyenv
if which pyenv > /dev/null; then
  export PATH="$HOME/.pyenv/shims:$PATH"
  eval "$(pyenv init -)"
fi

# npm https://qiita.com/PolarBear/items/62c0416492810b7ecf7c
export PATH=$PATH:$HOME/.nodebrew/current/bin

# go
export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"

# rust (rustup-init)
if [ -e $HOME/.cargo/env ]; then
  source $HOME/.cargo/env
fi

### brew ###

# brewで入れた方をmac内蔵より優先度高く探す
export PATH=/usr/local/bin:$PATH

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

export PATH="$HOME/bin:$PATH"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
