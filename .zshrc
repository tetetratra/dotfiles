# TODO
# - ターミナル上でAIを使えるようにする

if [ -f ~/.zshrc_configs ]; then
  source ~/.zshrc_configs
fi

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

# シェルを開いたタイミング & 移動したタイミングで、カレントディレクトリに.zshrc.localがあれば読み込む
if [[ -f .zshrc.local ]]; then
  source .zshrc.local
fi
chpwd() { # chpwd: zshが提供しているディレクトリ移動時に実行されるフック
  if [[ -f .zshrc.local ]]; then
    source .zshrc.local
  fi
}

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

# mise
eval "$(mise activate zsh)"

# 補完機能を有効にする
# fpath への追加(プラグインや ~/.zshrc_local の Docker 補完など)がすべて済んだあとに1回だけ実行する。
# 複数回実行したり、実行ごとに fpath が異なったりすると、毎回 ~/.zcompdump が作り直されて起動が遅くなる。
autoload -Uz compinit
compinit
