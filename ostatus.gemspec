# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ostatus/version"

Gem::Specification.new do |s|
  s.name        = "ostatus"
  s.version     = OStatus::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Hackers of the Severed Hand']
  s.email       = ['hotsh@xomb.org']
  s.homepage    = "http://github.com/hotsh/ostatus"
  s.summary     = %q{Implementations of the OStatus data stream objects.}
  s.description = %q{This project is to be used to jumpstart OStatus related projects that implement the PubSubHubbub protocols by providing the common fundamentals of Atom parsing and OStatus object creation.}

  s.rubyforge_project = "ostatus"

  s.add_dependency "ratom"
  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
