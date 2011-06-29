require 'test/unit'
require 'rubygems'
require 'bundler'
Bundler.setup File.expand_path("../../Gemfile", __FILE__)
require 'shoulda/context'
Dir.glob(File.expand_path("../../lib/**/*.rb", __FILE__)).each {|f| require f }
