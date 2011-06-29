require 'test/unit'
require 'socket'
require 'bundler'
ENV['BUNDLE_GEMFILE'] = File.expand_path("../../Gemfile", __FILE__)
require 'bundler/setup'
require 'shoulda/context'
require 'em-websocket'
require 'em-http'
require 'turn'
Dir.glob(File.expand_path("../../lib/**/*.rb", __FILE__)).each {|f| require f }

ENV["Nyoibo_ENV"] = "test"

Test::Unit::TestCase.module_eval do
  def failed
    EventMachine.stop
    fail
  end
end
