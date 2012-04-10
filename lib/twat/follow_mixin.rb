module FollowMixin
  POLLING_RESOLUTION = 20 # Readline scan time in hz
  # Shim to bail out if we're in test
  def untested
    true
  end

  class PrintNothing < Exception; end

  def run
    auth!
    enable_readline! if untested
    @tweetstack = ::Twat::TweetStack.new

    @failcount = 0

    # Get 5 tweets
    tweets = retrieve_tweets(:count => 5)
    while untested do
      begin
        last_id = process_followed(tweets) if tweets.any?
        (config.polling_interval * POLLING_RESOLUTION).times do
          reader.tick
          lines = 0
          reader.each_line do |i|
            lines += 1
            handle_input(i)
          end
          sleep 1.0/POLLING_RESOLUTION if lines == 0
        end
        tweets = retrieve_tweets(:since_id => last_id)
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

  def retrieve_tweets(opts)
    new_tweets(opts)
  rescue SocketError
    raise ::Twat::Exceptions::NoInternetConnection
  end

  def handle_input(inp)
    ret = process_input(inp)
    return if ret.nil?

    if ret === true
      reader.puts_above(inp.green)
    elsif ret === false
      reader.puts_above(inp.red)
    else
      reader.puts_above(ret)
    end
  rescue PrintNothing
    nil
  end

  def process_input(inp)
    case inp
    when /^[rR][tT] ([0-9]{1,2})/
      begin
        retweet($1.to_i)
        return true
      rescue ::Twat::Exceptions::NoSuchTweet
        return "#{inp.red} #{":: No such tweet".bold.red}"
      end
    when /^follow (.*)/
      Twitter.follow($1)
      return true
    else
      # Assume they want to tweet something
      if inp.length > 140
        return "#{inp.red} #{":: Too long".bold.red}"
      else
        Twitter.update(inp)
        return true
      end
    end
  end

  # Wrapper methods from the tweetstack implementation
  def retweet(idx)
    raise ::Twat::Exceptions::NoSuchTweet unless @tweetstack.include?(idx)
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
    last_id = nil
    tweets.reverse.each do |tweet|
      id = @tweetstack << tweet
      beep if config.beep? && tweet.text.mentions?(config.account_name)
      reader.puts_above format(tweet, @tweetstack.last)
      last_id = tweet.id
    end

    return last_id
  end

end
