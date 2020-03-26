require_relative "./boot.rb"

class App
  def self.start
    self.new
  end

  def initialize
    @iconfont = Iconfont.new
    @pkg = JSON.parse(File.read "./package.json")
    spinner = TTY::Spinner.new("[:spinner] Update ...", format: :spin)
    spinner.auto_spin
    start
    spinner.success
  end

  def start
    clean
    write
    save
    export
  end

  private

  def clean
    system "rm -rf dist/*"
  end

  def write
    res = @iconfont.download
    File.open("./dist/download.zip", "wb") do |file|
      file.write(res.body)
    end
  end

  def save
    detail = @iconfont.detail
    @iconfont.update detail.get("data.project.updated_at")
  end

  def export
    filename = "./dist/index.js"
    current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    js_header = [
      "/* name: #{@pkg["name"]}*/",
      "/* version: #{@pkg["version"]}*/",
      "/* Update time: #{current_time}*/",
      "/* Update By: abcft.wfe team */",
    ].join "\n"

    # mv dist file
    system "rm -rf ./dist/font*"
    system "cd dist && unzip -q download.zip"
    system "cp ./dist/font*/iconfont.js #{filename}"

    # add comments for latest update time
    file_content = File.read(filename)
    file_content = [js_header, file_content].join "\n\n"
    File.write(filename, file_content)
  end
end

App.start
