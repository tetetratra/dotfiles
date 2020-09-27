# 自作コマンドへのパス
export PATH=$PATH:~/bin
# manをvimで開く
export MANPAGER="col -b -x|vim -R -c 'set ft=man nolist nomod noma' -"
#historyの保存個数
export HISTSIZE=9999
#historyの重複を保存しない
export HISTCONTROL=ignoredups
#histoyを毎回保存＆ロードして、tmux間で共有
export PROMPT_COMMAND='history -a; history -r'
# Tex用
export PATH=$PATH:/Library/TeX/texbin
# go用?
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

