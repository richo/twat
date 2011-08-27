#!/usr/bin/env ruby

require 'twitter'
require 'yaml'
require 'optparse'
require 'oauth'

%w[config exceptions argparse actions].each do |filename|
  require "lib/twat/#{filename}"
end

module Twat
  class Twat
    def run
      begin
        action = Actions.new
        opts = ArgParse.new
        action.send(opts.options[:action], opts)
      rescue Usage
        opts.usage
      rescue NoSuchAccount
        puts "No such account"
        opts.usage
     rescue NoMethodError
       puts "No such command"
       opts.usage
      end
    end
  end
end
