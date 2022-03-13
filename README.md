
```bash
mkdir ~/p && cd p && git clone git@github.com:tetetratra/dotfiles.git && cd dotfiles

defaults write -globalDomain _HIHideMenuBar -bool true

defaults write -g com.apple.mouse.scaling 5
defaults write -g com.apple.scrollwheel.scaling 5

defaults write com.apple.finder FXPreferredViewStyle clmv
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.finder CreateDesktop -boolean false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder QLHidePanelOnDeactivate -bool true
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write -g NSWindowResizeTime 0.1
chflags nohidden ~/Library
killall Finder

defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock magnification -bool yes
defaults write com.apple.dock largesize -int 48
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mcx-expose-disabled -bool true
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock "mru-spaces" -bool "false"
killall Dock

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool "false"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool "false"

defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"
killall SystemUIServer

defaults write com.apple.screencapture "show-thumbnail" -bool "false"
defaults write com.apple.screencapture "type" -string "png"

defaults write com.apple.dashboard mcx-disabled -bool true

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

defaults write com.apple.terminal StringEncodings -array 4

networksetup -setdnsservers Wi-Fi 2001:4860:4860::8844 2001:4860:4860::8888 8.8.4.4 8.8.8.8
```

- ここでmacを再起動

```bash
xcode-select --install

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

cd ~/p/dotfiles && brew bundle --file ./manual/Brewfile

mas install 1429033973 # RunCat
mas install 931571202 # QuickShade

ln -sf $PWD/.tmux.conf ~/.tmux.conf
ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/.gitignore ~/.gitignore
ln -sf $PWD/.gitconfig ~/.gitconfig
ln -sf $PWD/init.vim ~/.config/nvim/init.vim
ln -sf $PWD/dein.toml ~/.config/nvim/dein/toml/dein.toml
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.gvimrc ~/.gvimrc
ln -sf $PWD/.ctags ~/.ctags

ln -sf $PWD/bin ~/bin

rbenv install 3.1.0
rbenv global 3.1.0
```

- `iterm.json`をインポート
- `Default.bttpreset`をインポート


## 手動で更新するもの

- `vimium-options.json`
  - オプションの一番下のBackupから取れる
- `Brewfile`
  - ` brew bundle dump`でBrewfileをダンプする
- `Default.bttpreset`
- `iterm.json`

