module Twat
  OAUTH_TOKENS = [ :oauth_token, :oauth_token_secret ]
  CONSUMER_TOKENS = [ :consumer_key, :consumer_secret ]
  class Actions

    attr_accessor :config, :opts

    def tweet
      twitter_auth

      Twitter.update(opts.msg)
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

    def setdefault
      unless config.accounts.include?opts[:account]
        raise NoSuchAccount
      end

      config[:default] = opts[:account]
      puts "Successfully set #{opts[:account]} as default"
    end

    def updateconfig
      puts "Sadly, not implemented"
    end

    def show
      puts account
      return
      twitter_auth
      Twitter.home_timeline.each_with_index do |tweet, idx|
        puts "#{tweet.user.screen_name.bold.cyan}: #{tweet.text}"

        break if idx == opts[:count]
      end
    end

    def user_feed
      twitter_auth

      begin
        Twitter.user_timeline(opts[:user]).first.tap do |tweet|
          puts "#{tweet.user.screen_name.bold.cyan}: #{tweet.text}"
        end
      rescue Twitter::NotFound
        puts "#{opts[:user].bold.red} doesn't appear to be a valid user"
      end
    end

    def version
      puts "twat: #{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"
    end

    def method_missing
      raise NoSuchCommand
    end

    private

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

    def account
      @account = config.accounts[account_name]
    end

    def account_name
      @account_name ||=
        if opts.include?(:account)
          opts[:account]
        else
          config.default_account.to_sym
        end
    end

  end
end
