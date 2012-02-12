module Twat
  OAUTH_TOKENS = [ :oauth_token, :oauth_token_secret ]
  CONSUMER_TOKENS = [ :consumer_key, :consumer_secret ]

  class Actions

    attr_accessor :config, :opts, :failcount

    def tweet
      twitter_auth

      raise TweetTooLong if opts.msg.length > 140

      Twitter.update(opts.msg)
      #puts opts.msg
    end

    # Add is somewhat of a special case, everything else hangs off config for
    # it's magic, However we're forced to do it manually here- config doesn't
    # know anything about it yet
    def add
      endpoint = Endpoint.new(opts[:endpoint])
      v = endpoint.consumer_info.map do |key, value|
        value
      end

      oauth_options = { :site => endpoint.url }
      oauth_options.merge!(endpoint.oauth_options)

      oauth = OAuth::Consumer.new( v[0], v[1], oauth_options )
      token_request = oauth.get_request_token()
      puts "Please authenticate the application at #{token_request.authorize_url}, then enter pin"
      pin = STDIN.gets.chomp
      begin
        access_token = token_request.get_access_token(oauth_verifier: pin)
        account_settings = {
          oauth_token: access_token.token,
          oauth_token_secret: access_token.secret,
          endpoint: opts[:endpoint]
        }
        config.accounts[opts[:account]] = account_settings
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

    def follow_user
      twitter_auth

      Twitter.follow(opts[:user])
    end

    def list_followers
      twitter_auth

      Twitter.followers.each do |follower|
        puts follower
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
      Twitter.home_timeline(:count => opts[:count]).reverse.each do |tweet|
        format(tweet)
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

    public

    def follow
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
        rescue Twitter::ServiceUnavailable
        rescue Interrupt
          if failcount > 2
            puts "3 consecutive failures, giving up"
          else
            sleeptime = 60 * (failcount + 1)
            print "(__-){".red
            puts ": the fail whale has been rolled out, sleeping for #{sleeptime} seconds"
            sleep sleeptime
            failcount += 1
          end
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

    def user_feed
      twitter_auth

      begin
        Twitter.user_timeline(opts[:user], :count => opts[:count]).each do |tweet|
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
        if twt.user.screen_name == config.account_name.to_s
          puts "#{twt.user.screen_name.bold.blue}: #{text}"
        elsif text.mentions?(config.account_name)
          puts "#{twt.user.screen_name.bold.red}: #{text}"
        else
          puts "#{twt.user.screen_name.bold.cyan}: #{text}"
        end
      else
        puts "#{twt.user.screen_name}: #{text}"
      end
    end

    def deentitize(text)
      {"&lt;" => "<", "&gt;" => ">", "&amp;" => "&", "&quot;" => '"', "&#39;" => '\'' }.each do |k,v|
        text.gsub!(k, v)
      end
      text
    end

    def twitter_auth
      Twitter.configure do |twit|
        config.account.each do |key, value|
          twit.send("#{key}=", value)
        end
        config.endpoint.consumer_info.each do |key, value|
          twit.send("#{key}=", value)
        end
        twit.endpoint = config.endpoint.url
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
      @account ||= config.accounts[account_name]
      unless @account
        raise NoSuchAccount
      else
        return @account
      end
    end

    def beep
      print "\a"
    end

  end
end
