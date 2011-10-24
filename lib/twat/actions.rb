module Twat
  OAUTH_TOKENS = [ :oauth_token, :oauth_token_secret ]
  CONSUMER_TOKENS = [ :consumer_key, :consumer_secret ]

  class Actions

    attr_accessor :config, :opts, :failcount


    # Add is somewhat of a special case, everything else hangs off config for
    # it's magic, However we're forced to do it manually here- config doesn't
    # know anything about it yet

    def delete
      if config.accounts.delete(opts[:account])
        config.save!
        puts "Successfully deleted"
      else
        puts "No such account"
      end
    end

    def updateconfig
      config.update!
    end



    public

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


  end
end
