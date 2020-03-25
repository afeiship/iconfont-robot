require "json"
require "nx"
require "nx-http"
require "tty-spinner"
require_relative "./iconfont.rb"

include Nx

file = File.read "./config.json"
CONFIG = JSON.parse(file)

class Check
  def initialize
    @iconfont = Iconfont.new
    update_if_changed
  end

  def sync_to_git
    system "npm run build"
    system "git add --all && git commit -m 'feat: submit by robot' && git push"
    system "npm version patch && git push --tags"
    system "npm publish"
  end

  def update_if_changed
    res = @iconfont.detail
    updated_at = res.get("data.project.updated_at")
    if @iconfont.changed?(updated_at)
      sync_to_git
      puts "[log]: #{Time.now} changed and updated"
    else
      puts "[log]: #{Time.now} not changed"
    end
  end

  def self.start
    self.new
  end
end

Check.start