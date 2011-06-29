# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nyoibo/version"

Gem::Specification.new do |s|
  s.name        = "nyoibo"
  s.version     = Nyoibo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["yalab"]
  s.email       = ["rudeboyjet@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Websocket uploader with progressbar.}
  s.description = %q{}

  s.rubyforge_project = "nyoibo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency("em-websocket", "~>0.3.0")
  s.add_dependency("json", "~>1.5.3")
  s.add_development_dependency('em-http-request', '~> 0.2.6')
end
