## 手動で更新するもの

- `vimium-options.json`
  - オプションの一番下のBackupから取れる
- `Brewfile`
  - `brew bundle dump`でBrewfileをダンプする
- `iterm.json`
  - preferences -> profiles -> other actions -> export as json -> all
- `karabiner-elements.json`
  - 新しい設定はここに書いてからアプリ側でインポートする

## macのクリーンインストール後に行うこと

```bash
defaults write -globalDomain _HIHideMenuBar -bool true

defaults write -g com.apple.trackpad.scaling -int 3
defaults write -g com.apple.trackpad.scrolling -int 1
defaults write -g com.apple.mouse.scaling 5
defaults write -g com.apple.scrollwheel.scaling 5

defaults write com.apple.keyboard.fnState -boolean true
defaults write -g AppleKeyboardUIMode -int 3

defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -bool true

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

# macOS Sonomaのかな漢字変換で表示される吹き出しを消す https://techracho.bpsinc.jp/hachi8833/2023_11_17/135935
sudo mkdir -p /Library/Preferences/FeatureFlags/Domain
sudo /usr/libexec/PlistBuddy -c "Add 'redesigned_text_cursor:Enabled' bool false" /Library/Preferences/FeatureFlags/Domain/UIKit.plist
```

- ここでmacを再起動
- sshの設定をする

```bash
xcode-select --install

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

mkdir ~/p && cd p && git clone git@github.com:tetetratra/dotfiles.git && cd dotfiles

cd ~/p/dotfiles && brew bundle --file ./manual/Brewfile

ln -sf $PWD/.tmux.conf ~/.tmux.conf
ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/.gitignore ~/.gitignore
ln -sf $PWD/.gitconfig ~/.gitconfig

ln -sf $PWD/neovim/init.lua ~/.config/nvim/init.lua
ln -sf $PWD/neovim/lua ~/.config/nvim/lua/
ln -sf $PWD/neovim/coc-settings.json ~/.config/nvim/coc-settings.json

ln -sf $PWD/.ctags ~/.ctags
ln -sf $PWD/.solargraph.yml ~/.solargraph.yml

ln -sf $PWD/manual/karabiner-elements.json ~/.config/karabiner/assets/complex_modifications/karabiner-elements.json
mkdir ~/bin && ln -sf $PWD/bin ~/bin

rbenv install 3.1.0 # よしなに
rbenv global 3.1.0
gem install neovim

pyenv install 3.10.3 # よしなに
pyenv global 3.10.3
pip install pynvim
```

- zshrcの拡張を手動でインストール
  - pure: https://github.com/sindresorhus/pure#manually
  - zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#manual-git-clone
- `iterm.json`をインポート
  - preferences -> profiles -> other actions -> import
- iterm -> preference -> keys -> navigation shortcuts
  - すべて[No Shortcut]にする(tmuxのwindow切り替えのため)
- iterm の Non-ASCII Font を nerd font にする
- システム環境設定
  - アクセシビリティ -> トラックパッド -> ダブルタップで選択
  - キーボード
    - キーボード -> 装飾キー -> capslockを[アクションなし]にする
    - ショートカット
      - すべてOFFにする
      - スクリーンショット, spotlightはONにする
      - キーボード -> 次のウィンドウを操作対象とする [ctrl スペース]
    - 音声入力 -> ショートカットキーをOFFにする
- google日本語入力を利用するようにする
  - 設定を変更
  - 辞書を登録
- clippyのキーボードショートカットの設定をする
- Better Touch Tool を設定する
  - global
    - `ctrl [1-9]`にアプリケーションを登録
      - 1: chrome
      - 2: iterm2
    - `ctrl shift alt [hjkl]`でwindow移動
  - Google Chrome
    - `ctrl l`で`ctrl tab`, `ctrl h`で`ctrl shift tab`
    - `ctrl [jknp]`で矢印キー
      - リピートは0.03間隔,0.06遅延
    - `command d`を無効化
    - `alt l`で`command l`を送る
  - iTerm
    - `ctrl 2`で`ctrl b ctrl b`を送る
    - `ctrl l`で`ctrl b ctrl n`を送る
    - `ctrl h`で`ctrl b ctrl p`を送る
    - `cmd l`で`ctrl l`を送る
      - 再帰的なトリガーを防ぐ、のチェックをつける
  - BTTが勝手に起動するバグに遭遇したときは `defaults write com.hegenberg.BetterTouchTool BTTDontShowPrefsOnReopen YES` の設定をすると直るかもしれない
    - https://qiita.com/take_3/items/08acebb07e313c89dea9
- Karabiner-Elements で "my confing" にある設定のみをすべてenableにする
- .gitconfig_local を作る
  ```.gitconfig_local
  # 例
  [user]
  name = tetetratra
  email = 44367208+tetetratra@users.noreply.github.com
  ```
- 壁紙をランダムにする
  - 設定->壁紙->「空撮をシャッフル: すべてをシャッフル」を選ぶ

