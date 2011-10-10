#!/usr/bin/env ruby

$:.push File.expand_path("../", __FILE__)
require 'twitter'
require 'yaml'
require 'optparse'
require 'oauth'

%w[config exceptions argparse actions migration options out].each do |filename|
  require "twat/#{filename}"
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

  def magenta
    "[35m#{self}[39m"
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
  VERSION_MINOR = 4
  VERSION_PATCH = 9

  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"
  class Twat
    def cli_run
      begin
        opts = ArgParse.new
        actor = Actions.new
        actor.config = config
        actor.opts = opts
        actor.send(opts.options[:action])
      rescue Usage
        opts.usage
      rescue NoSuchAccount
        Out.put "No such account"
        opts.usage
      rescue NoDefaultAccount
        Out.put "No default account configured."
      rescue NoSuchCommand
        Out.put "No such command"
        opts.usage
      rescue NoConfigFile
        Out.put "No config file, create one with twat -a [user|nick]"
        opts.usage
      rescue InvalidSetOpt
        Out.put "There is no such configurable option"
        opts.usage
      rescue RequiresOptVal
        Out.put "--set must take an option=value pair as arguments"
      rescue InvalidCredentials
        Out.put "Invalid credentials, try reauthenticating with"
        Out.put "twat -a #{opts[:account]}"
      rescue ConfigVersionIncorrect
        Out.put "Your config file is out of date. Run with --update-config to rememdy"
      rescue InvalidBool
        Out.put "Invalid value, valid values are #{Options::BOOL_VALID.join("|")}"
      rescue InvalidInt
        Out.put "Invalid value, must be an integer"
      end
    end
  end
end
