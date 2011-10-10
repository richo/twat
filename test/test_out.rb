#!/usr/bin/env ruby

$:.push(File.expand_path("../../", __FILE__))
require 'lib/twat'


Twat::Out.black("rawr")
Twat::Out.cyan("rawr")
Twat::Out.bold("rawr")
Twat::Out.bold.black("rawr")
Twat::Out.black.bold("rawr")

Twat::Out.cyan do |out|
  out.put "cyan, motherfuckers"
  out.red "red, fucken"
  out.bold "rawr"
  out.cyan.bold "ASDF"
end

Twat::Out.bold.cyan do |out|
  out.print "butts"
  out.print "butts"
end

Twat::Out.cyan.print "butts..."
Twat::Out.red "lol"

p = Twat::Out.new
p.cyan.print "Nick"
p.put ": rest of tweet"
