if [ -f ~/.zshrc_aliases ]; then
  source ~/.zshrc_aliases
fi

if [ -f ~/.zshrc_key_binds ]; then
  source ~/.zshrc_key_binds
fi

if [ -f ~/.zshrc_plugins ]; then
  source ~/.zshrc_plugins
fi

# ローカル独自の設定
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
# homebrewの自動アップデートをdisable
export HOMEBREW_NO_AUTO_UPDATE=1

### 言語 ###

# go
export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"

# rust (rustup-init)
if [ -e $HOME/.cargo/env ]; then
  source $HOME/.cargo/env
fi

### その他設定 ###
# direnv
eval "$(direnv hook zsh)"
export DIRENV_LOG_FORMAT=""

# ホームディレクトリのbinにパスを通す
export PATH="$HOME/bin:$PATH"

export PATH="/Users/kondo.daichi/.local/bin:$PATH"

eval "$(mise activate zsh)"
