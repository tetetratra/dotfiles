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
