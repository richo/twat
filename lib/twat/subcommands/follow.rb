module Twat::Subcommands
  POLLING_RESOLUTION = 20 # Readline scan time in hz
  class Follow < Base

    def run
      twitter_auth
      enable_readline!
      @tweetstack = ::Twat::TweetStack.new

      failcount = 0

      # Get 5 tweets
      tweets = Twitter.home_timeline(:count => 5)
      while true do
        begin
          last_id = process_followed(tweets) if tweets.any?
          (config.polling_interval * POLLING_RESOLUTION).times do
            begin
              reader.tick
              reader.each_line { |i| handle_input(i) }
            rescue TweetTooLong
              reader.puts_above "Too long".red
            end
            sleep 1.0/POLLING_RESOLUTION
          end
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

    def usage
      puts "Usage: twat"
      puts "Usage: twat follow_stream #hashtag"
    end

    private

    # @return last_id
    def process_followed(tweets)
      last_id = nil
      tweets.reverse.each do |tweet|
        id = @tweetstack << tweet
        beep if config.beep? && tweet.text.mentions?(config.account_name)
        reader.puts_above readline_format(tweet, @tweetstack.last)
        last_id = tweet.id
      end

      return last_id
    end

    def handle_input(inp)
      case inp
      when /[rR][tT] ([0-9]{1,2})/
        puts "Retweet not yet implemented"
        # begin
        #   retweet($1.to_i)
        # rescue NoSuchTweet
        #   print "No such tweet\n".red
        # end
      else
        # Assume they want to tweet something
        raise TweetTooLong if inp.length > 140

        Twitter.update(inp)
      end
    end

  end
  COMMANDS['follow_stream'] = Follow
end
