require 'em-websocket'
require 'json'
require 'nyoibo/configuration'
require 'nyoibo/daemon'
require 'nyoibo/callback'

module Nyoibo
  extend Configuration
  extend Daemon
  extend Callback::Runner
end
