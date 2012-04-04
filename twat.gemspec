# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "twat"

Gem::Specification.new do |s|
  s.name        = "twat"
  s.version     = Twat::VERSION
  s.authors     = ["Rich Healey"]
  s.email       = ["richo@psych0tik.net"]
  s.homepage    = "http://github.com/richoH/twat"
  s.summary     = "Command line tool for tweeting and whatnot"
  s.description = s.summary

  s.add_dependency "twitter"
  s.add_dependency "oauth"
  s.add_dependency "readline-ng", ">= 0.0.8"
  s.add_development_dependency "rake"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rspec"
  s.add_development_dependency "mktemp"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
