require 'em-websocket'
require 'json'
require 'nyoibo/configure'
require 'nyoibo/daemon'
require 'nyoibo/callback'

module Nyoibo
  extend Configure
  extend Daemon
  extend Callback::Runner
end
