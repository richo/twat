#!/usr/bin/env ruby

$:.push(File.expand_path("../../", __FILE__))
require 'lib/twat'

class Tweet
  attr_accessor :user, :text
end

class User
  attr_accessor :screen_name
end

twt = Tweet.new
twt.text= "Tweet goes here"
twt.user = User.new
twt.user.screen_name = "richo"
opts = Hash.new(account: "rich0H")
actions = Twat::Actions.new
config = Twat::Config.new
actions.opts = opts
actions.config = config


actions.format(twt)
twt.text = "Blah blah blah rich0H"
actions.format(twt)
twt.user.screen_name = "rich0H"
actions.format(twt)
