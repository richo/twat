module FollowMixin
  POLLING_RESOLUTION = 20 # Readline scan time in hz
  # Shim to bail out if we're in test
  def untested
    true
  end

  def run
    auth!
    enable_readline! if untested
    @tweetstack = ::Twat::TweetStack.new

    @failcount = 0

    # Get 5 tweets
    tweets = new_tweets(:count => 5)
    while untested do
      begin
        process_followed(tweets) if tweets.any?
        (config.polling_interval * POLLING_RESOLUTION).times do
          begin
            reader.tick
            reader.each_line { |i| handle_input(i) }
          rescue TweetTooLong
            reader.puts_above "Too long".red
          end
          sleep 1.0/POLLING_RESOLUTION
        end
        tweets = new_tweets
        @failcount = 0
      rescue Interrupt
        break
      rescue Twitter::Error::ServiceUnavailable
        break unless fail_or_bail
        sleeptime = 60 * (@failcount + 1)
        reader.puts_above "#{"(__-){".red}: the fail whale has been rolled out, sleeping for #{sleeptime} seconds"
        reader.wait sleeptime
      rescue Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError
        break unless fail_or_bail
      end
    end
  end

  private

  def handle_input(inp)
    case inp
    when /[rR][tT] ([0-9]{1,2})/
      begin
        retweet($1.to_i)
      rescue NoSuchTweet
        print "No such tweet\n".red
      end
    when /follow (.*)/
      Twitter.follow($1)
    else
      # Assume they want to tweet something
      raise TweetTooLong if inp.length > 140

      Twitter.update(inp)
    end
  end

  # Wrapper methods from the tweetstack implementation
  def retweet(idx)
    raise NoSuchTweet unless @tweetstack.include?(idx)
    Twitter.retweet(@tweetstack[idx].id)
  end

  def fail_or_bail
    if @failcount > 2
      puts "3 consecutive failures, giving up"
    else
      @failcount += 1
      return true
    end
  end

  def process_followed(tweets)
    tweets.reverse.each do |tweet|
      beep if config.beep? && tweet.text.mentions?(config.account_name)
      reader.puts_above readline_format(tweet, @tweetstack.last)
    end
  end

end
