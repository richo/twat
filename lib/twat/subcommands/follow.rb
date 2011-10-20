module Twat::Subcommands
  class Follow

    def run
      # I can't see any way to poll the server for updates, so in the meantime
      # we will have to retrieve a few tweets from the timeline, and then poll
      # occasionally :/
      twitter_auth
      failcount = 0

      # Get 5 tweets
      tweets = Twitter.home_timeline(:count => 5)
      while true do
        begin
          last_id = process_followed(tweets) if tweets.any?
          sleep config.polling_interval
          tweets = Twitter.home_timeline(:since_id => last_id)
          failcount = 0
        rescue Interrupt
          break
        rescue Errno::ECONNRESET
        rescue Errno::ETIMEDOUT
          if failcount > 2
            puts "3 consecutive failures, giving up"
          else
            failcount += 1
          end
        end
      end
    end

    private

    # @return last_id
    def process_followed(tweets)
      last_id = nil
      tweets.reverse.each do |tweet|
        beep if config.beep? && tweet.text.mentions?(config.account_name)
        format(tweet)
        last_id = tweet.id
      end

      return last_id
    end

  end
  COMMANDS['follow'] = Follow
end
