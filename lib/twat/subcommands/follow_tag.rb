module Twat::Subcommands
  class FollowTag < Base
    include FollowMixin

    attr_accessor :twit

    def self.usage
      ["Usage: twat",
        "Usage: twat follow_stream #hashtag"]
    end

    def new_tweets(opts)
      if twit
        twit.new_tweets
      else
        # initialise twit
        if @argv.empty?
          twit = ::Twat::Models::Tweets.new(:home_timeline)
        else
          twit = ::Twat::Models::Tweets.new(:search, @argv.join(" "))
        end
        twit.raw(:count => 5)
      end
    end
  end
  COMMANDS['follow_tag'] = FollowTag
end
