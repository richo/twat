#!/usr/bin/env ruby

$:.push File.expand_path("../", __FILE__)
require 'twitter'
require 'yaml'
require 'optparse'
require 'oauth'

Dir.glob("twat/*").each do |filename|
  require filename
end

module Twat
  VERSION_MAJOR = 0
  VERSION_MINOR = 2
  VERSION_PATCH = 5

  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"
  class Twat
    def run
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
      end
    end
  end
end
