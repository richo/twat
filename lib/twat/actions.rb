module Twat
  OAUTH_TOKENS = [ :oauth_token, :oauth_token_secret ]
  CONSUMER_TOKENS = [ :consumer_key, :consumer_secret ]
  class Actions

    attr_accessor :config, :opts, :failcount

    def tweet
      twitter_auth

      raise TweetTooLong if opts.msg.length > 140

      twitter.update(opts.msg)
      #puts opts.msg
    end

    def add
      v = Config.consumer_info.map do |key, value|
        value
      end
      # FIXME probably allow something other than 
      # twitter
      oauth = OAuth::Consumer.new( v[0], v[1],
              { site: "http://twitter.com" })
      token_request = oauth.get_request_token()
      puts "Please authenticate the application at #{token_request.authorize_url}, then enter pin"
      pin = gets.chomp
      begin
        access_token = token_request.get_access_token(oauth_verifier: pin)
        config.accounts[opts[:account]] = {
          oauth_token: access_token.token,
          oauth_token_secret: access_token.secret
        }
        config.save!
      rescue OAuth::Unauthorized
        puts "Couldn't authenticate you, did you enter the pin correctly?"
      end
    end

    def delete
      if config.accounts.delete(opts[:account])
        config.save!
        puts "Successfully deleted"
      else
        puts "No such account"
      end
    end

    def setoption
      k, v = opts[:optval].split("=")
      raise RequiresOptVal unless v
      options = Options.new
      options.send(:"#{k}=", v)

      puts "Successfully set #{k} as #{v}"
    end

    def updateconfig
      config.update!
    end

    def show
      twitter_auth
      twitter.home_timeline(:count => opts[:count]).each do |tweet|
        format(tweet)
      end
    end

    private

    # @return last_id
    def process_followed(tweets)
      last_id = nil
      tweets.reverse.each do |tweet|
        beep if config.beep? && tweet.text.mentions?(account_name)
        format(tweet)
        last_id = tweet.id
      end

      return last_id
    end

    public

    def follow
      # I can't see any way to poll the server for updates, so in the meantime
      # we will have to retrieve a few tweets from the timeline, and then poll
      # occasionally :/
      twitter_auth
      failcount = 0

      # Get 5 tweets
      tweets = twitter.home_timeline(:count => 5)
      while true do
        begin
          last_id = process_followed(tweets) if tweets.any?
          sleep config.polling_interval
          tweets = twitter.home_timeline(:since_id => last_id)
          failcount = 0
        rescue Interrupt
          break
        rescue Errno::ECONNRESET
          if failcount > 2
            puts "3 consecutive failures, giving up"
          else
            failcount += 1
          end
        end
      end
    end

    def user_feed
      twitter_auth

      begin
        twitter.user_timeline(opts[:user], :count => opts[:count]).each do |tweet|
          format(tweet)
        end
      rescue Twitter::NotFound
        puts "#{opts[:user].bold.red} doesn't appear to be a valid user"
      end
    end

    def version
      puts "twat: #{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"
    end

    def method_missing(sym, *args, &block)
      raise NoSuchCommand
    end

    private

    # Format a tweet all pretty like
    def format(twt)
      text = deentitize(twt.text)
      if config.colors?
        if twt.user.screen_name == account_name.to_s
          puts "#{twt.user.screen_name.bold.blue}: #{text}"
        elsif text.mentions?(account_name)
          puts "#{twt.user.screen_name.bold.red}: #{text}"
        else
          puts "#{twt.user.screen_name.bold.cyan}: #{text}"
        end
      else
        puts "#{twt.user.screen_name}: #{text}"
      end
    end

    def deentitize(text)
      {"&lt;" => "<", "&gt;" => ">", "&amp;" => "&", "&quot;" => '"' }.each do |k,v|
        text.gsub!(k, v)
      end
      text
    end

    def twitter_auth
      Twitter.configure do |twit|
        account.each do |key, value|
          twit.send("#{key}=", value)
        end
        Config.consumer_info.each do |key, value|
          twit.send("#{key}=", value)
        end
      end
    end

    def account_name
      @account_name ||=
        if opts.include?(:account)
          opts[:account]
        else
          config[:default]
        end
    end

    def account
      @account = config.accounts[account_name]
    end

    def account_name
      @account_name ||=
        if opts.include?(:account)
          opts[:account]
        else
          config.default_account
        end
    end

    def beep
      print "\a"
    end

    def twitter
      @twitter = if account[:endpoint]
          Twitter.new( endpoint: account[:endpoint] )
        else
          Twitter.new
        end
    end

  end
end
