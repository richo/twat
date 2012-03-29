module TwitterMixin

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

  def new_tweets(opts)
    unless @argv.empty?
      ret = Twitter.search(@argv.join(" "), opts)
    else
      ret = Twitter.home_timeline(opts)
    end
  end

  def new_mentions(opts)
    ret = Twitter.mentions(opts)
  end
end
