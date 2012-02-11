#!/usr/bin/env ruby

$:.push File.expand_path("../", __FILE__)
require 'twitter'
require 'yaml'
require 'optparse'
require 'oauth'

%w[config exceptions argparse actions migration options endpoint].each do |filename|
  require "twat/#{filename}"
end

%w[follow tweet add delete follow_user updateconfig setoption show user_feed].each do |filename|
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
  VERSION_MAJOR = 0
  VERSION_MINOR = 5
  VERSION_PATCH = 3

  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"
  class Twat

    include HandledExceptions

    def cli_run
      # FIXME Handing in the opts like this feels dirty
      with_handled_exceptions(ArgParse.new) do |opts|
        actor = Actions.new

        if opts[:account] && opts[:action] != :add
          config.account = opts[:account]
        end

        actor.config = config
        actor.opts = opts
        actor.send(opts.options[:action])
      end
    end
  end
end
