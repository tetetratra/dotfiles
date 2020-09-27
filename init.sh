#!/bin/sh

ln -sf $PWD/.bashrc ~/.bashrc
ln -sf $PWD/.irbrc ~/.irbrc
ln -sf $PWD/.pryrc ~/.pryrc
ln -sf $PWD/.rubocop.yml ~/.rubocop.yml
ln -sf $PWD/.tmux.conf ~/.tmux.conf
ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/.gitignore ~/.gitignore
ln -sf $PWD/.gitconfig ~/.gitconfig
ln -sf $PWD/init.vim ~/.config/nvim/init.vim
ln -sf $PWD/toml ~/.config/nvim/dein/
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.gvimrc ~/.gvimrc
ln -sf $PWD/.ctags ~/.ctags
ln -sf $PWD/.my.cnf ~/.my.cnf

# ~/bin に予めパスを通しておく
if ! test -d ~/bin; then
  mkdir ~/bin
  echo "please set PATH to ~/bin"
fi

ln -sf $PWD/bin/tmux_status_bar ~/bin/tmux_status_bar
ln -sf $PWD/bin/set_uec_git_proxy ~/bin/set_uec_git_proxy
ln -sf $PWD/bin/unset_uec_git_proxy ~/bin/unset_uec_git_proxy

