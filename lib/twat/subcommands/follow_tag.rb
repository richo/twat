module Twat::Subcommands
  class FollowTag < Base
    include FollowMixin

    def self.usage
      ["Usage: twat",
        "Usage: twat follow_stream #hashtag"]
    end

    def new_tweets(opts)
      unless @argv.empty?
        ret = Twitter.search(@argv.join(" "), opts)
      else
        ret = Twitter.home_timeline(opts)
      end
    end
  end
  COMMANDS['follow_tag'] = FollowTag
end
