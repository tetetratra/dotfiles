$VERBOSE = nil # 警告を表示させない
require 'awesome_print'
AwesomePrint.irb!

# 31: 赤, 34: 青, 32: 緑, 33: 黄, 35: 桃, 36: 水
IRB.conf[:PROMPT][:MY_PROMPT] = {
  :PROMPT_I => "\e[31;1m❯❯\e[m ",    # 通常時のプロンプト
  :PROMPT_N => "\e[34;1m▏▏\e[m ",  # 継続行のプロンプト
  :PROMPT_S => "\e[36;1m❯❯\e[m ",    # 文字列などの継続行のプロンプト
  :PROMPT_C => "\e[32;1m❯❯\e[m ",    # 式が継続している時のプロンプト
  :RETURN   => "    ==>%s\n"   # メソッドから戻る時のプロンプト
}
# プロンプトモード MY_PROMPT を使う
IRB.conf[:PROMPT_MODE] = :MY_PROMPT
