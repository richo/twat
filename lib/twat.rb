#!/usr/bin/env ruby

$:.push File.expand_path("../", __FILE__)
require 'twitter'
require 'yaml'
require 'optparse'
require 'oauth'

%w[config exceptions argparse actions].each do |filename|
  require "twat/#{filename}"
end

module Twat
  VERSION_MAJOR = 0
  VERSION_MINOR = 9000
  VERSION_PATCH = 0

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
      rescue NoMethodError
        puts "No such command"
        opts.usage
      rescue NoConfigFile
        puts "No config file, create one with twat -a [user|nick]"
        opts.usage
      rescue InvalidCredentials
        puts "Invalid credentials, try reauthenticating with"
        puts "twat -a #{opts[:account]}"
      end
    end
  end
end
