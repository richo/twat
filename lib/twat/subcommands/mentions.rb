module Twat::Subcommands
  POLLING_RESOLUTION = 20
  class Mentions < Base
  include FollowMixin

  def self.usage
    "Usage: twat mentions"
  end

  def new_tweets(opts)
    ret = Twitter.mentions(opts)
  end

  end
  COMMANDS['mentions'] = Mentions
end
