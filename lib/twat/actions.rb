module Twat
  OAUTH_TOKENS = [ :oauth_token, :oauth_token_secret ]
  CONSUMER_TOKENS = [ :consumer_key, :consumer_secret ]

  class Actions

    attr_accessor :config, :opts, :failcount

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
