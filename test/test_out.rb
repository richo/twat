#!/usr/bin/env ruby

$:.push(File.expand_path("../../", __FILE__))
require 'lib/twat'


Twat::Out.black("rawr")
Twat::Out.cyan("rawr")

Twat::Out.cyan do |out|
  out.put "cyan, motherfuckers"
  out.red "red, fucken"
  out.bold "rawr"
  out.cyan.bold "ASDF"
end
