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
        configure do |twat|
          opts.options.each do |key, value|
            twat.send(:"#{key}=", value)
          end
        end
        action = Actions.new
        action.send(opts.options[:action], opts)
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

    # Stuff these off into a seperate piece of code somewhere
    def configure(&block)
      yield config

      # If I understand correctly, I can check over what's
      # happened here?
    end

    def config
      @config ||= Config.new
    end

  end
end
