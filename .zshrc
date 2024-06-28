alias l='ls -AlFGhv'
alias ls='ls -AFGv'
alias t='tr "\n" " "'
alias g='git'
alias tree='tree -a'
alias less='less -R'
alias p='pbpaste'
alias c='pbcopy'
alias o='open'
alias be='bundle exec'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias rm='trash'
alias d='docker'
alias dc='docker-compose'
alias dcrb='(){ docker-compose run --rm $1 bash -c "/bin/bash" }'
alias n='nvim'
alias nvim='nvim -p'
alias tree='tree --charset unicode'
alias history='history -E 1'
alias blue='tmux set-option -p -t : window-style bg=colour17' # 現在(-t :)のpane(-p)の背景色を変更
alias red='tmux set-option -p -t : window-style bg=colour52'

### ローカル独自の設定 ###
if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

### zsh ###

# cd後にlsとgit statusする https://qiita.com/puriketu99/items/e3c85fbe0fc4b939d0e2
setopt auto_cd
function chpwd() {
  ls
  git status --short 2> /dev/null
}

# manをnvimのfiletype=manかつ読み込みモードで開く
# タグジャンプとかが使えて便利
# 参考: https://rcmdnk.com/blog/2014/07/20/computer-vim/
# colコマンドの -b はバックスペースを使って戻ることができるようにするもの。-x はタブをスペースに変換するもの。
# nomodifiedがないと、閉じるときに毎回未保存の警告が出てしまうため必要
export MANPAGER="col -b -x | nvim -c 'set filetype=man nomodified' -"
# 大文字小文字に関わらず, 候補が見つからない時のみ文字種を無視した補完をする
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
# 補完機能を有効にする
autoload -U compinit; compinit
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=01;34:su=41;30:sg=46;30:tw=42;30:ow=01;36'
zstyle ':completion:*' list-colors "${LS_COLORS}" # 補完候補のカラー表示
# コマンド提案
setopt correct
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
# brewで入れた方をmac内蔵より優先度高く探す
export PATH=/usr/local/bin:$PATH
# 自動アップデートをdisable
export HOMEBREW_NO_AUTO_UPDATE=1

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

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# homebrew
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

# https://stackoverflow.com/questions/61466461/yank-in-visual-vim-mode-in-zsh-does-not-copy-to-clipboard-in-ordert-to-paste-w
function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | tr -d "\n" | pbcopy -i
}
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

### plugin ###

# zinit
# https://github.com/zdharma-continuum/zinit#manual
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# zsh-syntax-highlighting
zinit load zsh-users/zsh-syntax-highlighting

# pure
zinit load sindresorhus/pure
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

# zsh-autosuggestions
zinit load zsh-users/zsh-autosuggestions

# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

export PATH="$HOME/bin:$PATH"

# direnv
eval "$(direnv hook zsh)"
