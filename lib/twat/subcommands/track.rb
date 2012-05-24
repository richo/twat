require 'ostruct'
module Twat::Subcommands
  class Track < Base
    include FollowMixin

    # TODO configless mixin
    def auth! # Disable authentication
    end

    def config # Stub out a config object
      @_config ||= if (c = super).exists?
                     c
                   else
                     OpenStruct.new({
                       :polling_interval => 60,
                       :colors? => true,
                       :beep? => false,
                       :account_name => "IMPOSSIBLEUSERNAME!"
                     })
                   end
    end

    def self.usage
      ["Usage: twat track username"]
    end

    def new_tweets(opts)
      Twitter.user_timeline(@argv[0], opts)
    end

  end
  COMMANDS['track'] = Track
end
