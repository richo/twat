#!/usr/bin/env ruby

$:.push File.expand_path("../", __FILE__)
require 'twitter'
require 'yaml'
require 'optparse'
require 'oauth'
require 'readline-ng'

%w[endpoint exceptions config argparse migration options
  subcommand version tweetstack].each do |filename|
  require "twat/#{filename}"
end

%w[follow tweet add delete follow_user updateconfig setoption show user_feed version].each do |filename|
  require "twat/actions/#{filename}"
end

class String
  # TODO - It'd be nice to implement the colors support here, maybe even only
  # mix this in if it's enabled?
  def red
    "[31m#{self}[39m"
  end

  def green
    "[32m#{self}[39m"
  end

  def yellow
    "[33m#{self}[39m"
  end

  def blue
    "[34m#{self}[39m"
  end

  def cyan
    "[36m#{self}[39m"
  end

  def bold
    "[1m#{self}[22m"
  end

  def mentions?(name)
    return self.downcase.include?(name.to_s.downcase)
  end
end

module Twat
  class Twat

    def cli_run
      # FIXME exception handling is gone for now
      Subcommand.run
    end
  end
end
