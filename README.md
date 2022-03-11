手動更新

- `vimium-options.json`
  - オプションの一番下のBackupから取れる
- `Brewfile`
  - Brewfileがあるディレクトリで`brew bundle`をしてインストール
  - ` brew bundle dump`でBrewfileをダンプする


```bash
ln -sf $PWD/.irbrc ~/.irbrc
ln -sf $PWD/.pryrc ~/.pryrc
ln -sf $PWD/.rubocop.yml ~/.rubocop.yml
ln -sf $PWD/.tmux.conf ~/.tmux.conf
ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/.gitignore ~/.gitignore
ln -sf $PWD/.gitconfig ~/.gitconfig
ln -sf $PWD/init.vim ~/.config/nvim/init.vim
ln -sf $PWD/dein.toml ~/.config/nvim/dein/toml/dein.toml
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.gvimrc ~/.gvimrc
ln -sf $PWD/.ctags ~/.ctags
ln -sf $PWD/.my.cnf ~/.my.cnf

ln -sf $PWD/bin ~/bin
```
