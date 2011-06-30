require 'em-websocket'
require "json"

module Nyoibo
  extend Configuration
  extend Daemon
  extend Callback::Runner
end
