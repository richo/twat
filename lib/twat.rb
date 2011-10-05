#!/usr/bin/env ruby

$:.push File.expand_path("../", __FILE__)
require 'twitter'
require 'yaml'
require 'optparse'
require 'oauth'

%w[config exceptions argparse actions migration options].each do |filename|
  require "twat/#{filename}"
end

class String
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
end

module Twat
  VERSION_MAJOR = 0
  VERSION_MINOR = 4
  VERSION_PATCH = 1

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
        puts "No such account"
        opts.usage
      rescue NoDefaultAccount
        puts "No default account configured."
      rescue NoSuchCommand
        puts "No such command"
        opts.usage
      rescue NoConfigFile
        puts "No config file, create one with twat -a [user|nick]"
        opts.usage
      rescue InvalidSetOpt
        puts "There is no such configurable option"
        opts.usage
      rescue RequiresOptVal
        puts "--set must take an option=value pair as arguments"
      rescue InvalidCredentials
        puts "Invalid credentials, try reauthenticating with"
        puts "twat -a #{opts[:account]}"
      rescue ConfigVersionIncorrect
        puts "Your config file is out of date. Run with --update-config to rememdy"
      end
    end
  end
end
