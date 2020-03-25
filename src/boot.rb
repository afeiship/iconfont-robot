require "json"
require "nx"
require "nx-http"
require "tty-spinner"
require_relative "./iconfont.rb"

include Nx

CONFIG = JSON.parse(File.read "./config.json")
