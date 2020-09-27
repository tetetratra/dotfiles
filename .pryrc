$VERBOSE = nil # 警告を表示させない
puts
require "awesome_print"
AwesomePrint.pry!
Pry.config.editor = "vim"

Pry.config.commands.command "copy", "Copy last evaluated object to clipboard" do
  pbcopy _pry_.last_result.ai(:plain => true, :indent => 2, :index => false)
  output.puts "Copied!"
end

def pbcopy(str, opts = {})
  IO.popen('pbcopy', 'r+') { |io| io.print str }
end

class Object
  def download(file_name = 'tmp_pry.html')
    File.open(Dir.home + '/Downloads/' + file_name, 'w') do |f|
      f.puts(self)
    end
    puts "Downloaded!"
  end
end

Pry.config.prompt = [proc { "\e[31;1m❯❯\e[m " }, proc { "\e[34;1m▏▏\e[m "}]

