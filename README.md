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

<details> <summary> コマンドその1 </summary>

```bash
# メニューバーを自動的に隠す
defaults write -globalDomain _HIHideMenuBar -bool true

# トラックパッドのポインタ移動速度を速くする (0-3 の範囲)
defaults write -g com.apple.trackpad.scaling -int 3
# トラックパッドのスクロール速度を設定
defaults write -g com.apple.trackpad.scrolling -int 1
# マウスのポインタ移動速度を速くする
defaults write -g com.apple.mouse.scaling 5
# スクロールホイールのスクロール速度を速くする
defaults write -g com.apple.scrollwheel.scaling 5

# F1–F12 をデフォルトでファンクションキーとして使う
defaults write com.apple.keyboard.fnState -boolean true
# フルキーボードアクセスをすべての操作に拡張
defaults write -g AppleKeyboardUIMode -int 3

# 内蔵トラックパッドでタップでクリックを有効化
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# Bluetooth トラックパッドでタップでクリックを有効化
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# Magic Mouse などでタップでクリックを有効化
defaults -currentHost write -g com.apple.mouse.tapBehavior -bool true

# Finder のデフォルト表示をカラムビューにする
defaults write com.apple.finder FXPreferredViewStyle clmv
# Finder で隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles -boolean true
# デスクトップ上のアイコンを非表示にする
defaults write com.apple.finder CreateDesktop -boolean false
# Finder タイトルバーにフルパスを表示
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Finder のステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true
# Finder のパスバーを表示
defaults write com.apple.finder ShowPathbar -bool true
# アプリが非アクティブになったら Quick Look パネルを閉じる
defaults write com.apple.finder QLHidePanelOnDeactivate -bool true
# Quick Look でテキスト選択を可能にする
defaults write com.apple.finder QLEnableTextSelection -bool true
# ウインドウリサイズのアニメーション時間を短縮
defaults write -g NSWindowResizeTime 0.1
# ユーザ Library フォルダを表示
chflags nohidden ~/Library
# Finder を再起動して設定を反映
killall Finder

# Dock から固定アプリをすべて削除
defaults write com.apple.dock persistent-apps -array
# Dock のアイコンサイズを 32px に設定
defaults write com.apple.dock tilesize -int 32
# Dock の拡大を有効化
defaults write com.apple.dock magnification -bool yes
# Dock 拡大時の最大サイズを 48px に設定
defaults write com.apple.dock largesize -int 48
# Dock 自動表示の遅延をゼロに
defaults write com.apple.dock autohide-delay -float 0
# Dock を自動的に隠す
defaults write com.apple.dock autohide -bool true
# Mission Control（Exposé）を無効化
defaults write com.apple.dock mcx-expose-disabled -bool true
# Dock に最近使ったアプリを表示しない
defaults write com.apple.dock "show-recents" -bool "false"
# スペースを最近の使用順に並べ替えない
defaults write com.apple.dock "mru-spaces" -bool "false"
# Dock を再起動して設定を反映
killall Dock

# フルキーボードアクセスをすべての操作に拡張（グローバル）
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# F1–F12 をデフォルトでファンクションキーとして使う（グローバル）
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
# キーリピート速度を速く
defaults write NSGlobalDomain KeyRepeat -int 2
# キーリピート開始までの遅延を短く（15）
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# すべてのファイル拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# 新規書類を iCloud ではなくローカルに保存
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# ナチュラルスクロール方向を有効化
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
# 自動大文字化を無効化
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool "false"
# 自動スペル補正を無効化
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool "false"

# メニューバーにバッテリー残量（％）を表示
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
# メニューバー時計の書式をカスタマイズ
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"
# SystemUIServer を再起動して設定を反映
killall SystemUIServer

# スクリーンショットのサムネイルプレビューを無効化
defaults write com.apple.screencapture "show-thumbnail" -bool "false"
# スクリーンショットの保存形式を PNG に設定
defaults write com.apple.screencapture "type" -string "png"

# Dashboard を無効化
defaults write com.apple.dashboard mcx-disabled -bool true

# ネットワーク／USB ボリュームに .DS_Store を作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"

# Terminal のデフォルト文字コードを UTF-8 に設定
defaults write com.apple.terminal StringEncodings -array 4

# Wi-Fi の DNS サーバーを Google Public DNS に設定 (IPv6 & IPv4)
networksetup -setdnsservers Wi-Fi 2001:4860:4860::8844 2001:4860:4860::8888 8.8.4.4 8.8.8.8

# macOS Sonoma のかな漢字変換で表示される吹き出しを消す
# UIKit のフラグを編集して redesigned_text_cursor を無効化している
# ref: https://techracho.bpsinc.jp/hachi8833/2023_11_17/135935
sudo mkdir -p /Library/Preferences/FeatureFlags/Domain
sudo /usr/libexec/PlistBuddy -c "Add 'redesigned_text_cursor:Enabled' bool false" /Library/Preferences/FeatureFlags/Domain/UIKit.plist
```

</details>


- ここでmacを再起動
- sshの設定をする

<details> <summary> コマンドその2 </summary>

```bash
# Xcode Command Line Tools をインストール（gccなどを含む）
xcode-select --install

# Homebrew をインストール（公式のインストールスクリプトを使用）
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

mkdir -p ~/p
mkdir -p ~/bin
mkdir -p ~/.config/mise
mkdir ~/.config/nvim/lua

git clone git@github.com:tetetratra/dotfiles.git ~/p/dotfiles

brew bundle --file ~/p/dotfiles/manual/Brewfile

ln -sf ~/p/dotfiles/.mise_config.toml              ~/.config/mise/config.toml
ln -sf ~/p/dotfiles/.tmux.conf                     ~/.tmux.conf
ln -sf ~/p/dotfiles/.zshrc                         ~/.zshrc
ln -sf ~/p/dotfiles/.zshrc_aliases                 ~/.zshrc_aliases
ln -sf ~/p/dotfiles/.zshrc_key_binds               ~/.zshrc_key_binds
ln -sf ~/p/dotfiles/.zshrc_plugins                 ~/.zshrc_plugins
ln -sf ~/p/dotfiles/.zshrc_configs                 ~/.zshrc_configs
ln -sf ~/p/dotfiles/.gitignore                     ~/.gitignore
ln -sf ~/p/dotfiles/.gitconfig                     ~/.gitconfig
ln -sf ~/p/dotfiles/.ctags                         ~/.ctags
ln -sf ~/p/dotfiles/.solargraph.yml                ~/.solargraph.yml
ln -sf ~/p/dotfiles/nvim/init.lua                  ~/.config/nvim/init.lua
ln -sf ~/p/dotfiles/nvim/lua                       ~/.config/nvim/lua/
ln -sf ~/p/dotfiles/nvim/coc-settings.json         ~/.config/nvim/coc-settings.json
ln -sf ~/p/dotfiles/manual/karabiner-elements.json ~/.config/karabiner/assets/complex_modifications/karabiner-elements.json
ln -sf ~/p/dotfiles/bin                            ~/bin

mise install
```

</details>

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
      - 3: Slack
    - `ctrl shift alt h, l`でwindowを左右分割
    - `ctrl shift alt j`でwindowを全画面表示
    - `ctrl shift alt k`でwindowを移動
    - `ctrl shift alt n, p`でwindowを上下分割
  - Google Chrome
    - `ctrl l`で`ctrl tab`
    - `ctrl h`で`ctrl shift tab`
    - `command d`を無効化
  - iTerm
    - `ctrl 2`で`ctrl b ctrl b`を送る
    - `ctrl space`で`ctrl b ctrl n`を送る
    - `ctrl shift space`で`ctrl b ctrl p`を送る
    - `cmd shift l`(karabinarが効いているので`shift →`)で`ctrl b ctrl n`を送る
    - `cmd shift h`(karabinarが効いているので`shift ←`)で`ctrl b ctrl p`を送る
  - Slack
    - `ctrl 3` で `cmd shift a` を送る
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

