require "json"
require "nx-http"
require_relative "./iconfont.rb"

include Nx

CONFIG = JSON.parse(File.read "./config.json")

class App
  def self.start
    self.new
  end

  def initialize
    clean
    write
    export
  end

  def clean
    system "rm -rf dist/*"
  end

  def write
    res = Iconfont.new(CONFIG["cookie"], CONFIG["url"]).download
    File.open("./dist/download.zip", "wb") do |file|
      file.write(res.body)
    end
  end

  def export
    filename = "./dist/index.js"
    current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    js_header = [
      "/* Update time: #{current_time}*/",
      "/* Update By: abcft.bi team */",
    ].join "\n"

    # mv dist file
    system "rm -rf ./dist/font*"
    system "cd dist && unzip download.zip"
    system "cp ./dist/font*/iconfont.js #{filename}"

    # add comments for latest update time
    file_content = File.read(filename)
    file_content = [js_header, file_content].join "\n\n"
    File.write(filename, file_content)
  end
end
