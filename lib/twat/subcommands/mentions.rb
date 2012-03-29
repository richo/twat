module Twat::Subcommands
  POLLING_RESOLUTION = 20
  class Mentions < Base

    include TwitterMixin

    def untested
      true
    end

    def run
      auth!
      enable_readline! if untested

      @tweetstack = ::Twat::TweetStack.new

      mentions = new_mentions(:count => 5)
      while untested do
        last_id = process_followed(mentions) if mentions.any?
        sleep config.polling_interval
        mentions = new_mentions(:count => 5, :since => last_id)
      end
    end


  end
  COMMANDS['mentions'] = Mentions
end
