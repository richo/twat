module Twat
  OAUTH_TOKENS = [ :oauth_token, :oauth_token_secret ]
  CONSUMER_TOKENS = [ :consumer_key, :consumer_secret ]


  class Actions

    attr_accessor :config, :opts, :failcount

    def method_missing(sym, *args, &block)
      raise NoSuchCommand
    end

    private

    def pad(n)
      "%02d" % n
    end

    def output(twt, idx = nil)
      out = format(twt, idx)
      if defined?(Curses)
        Curses.addstr(out)
      else
        puts(out)
      end
    end

    # Format a tweet all pretty like
    def format(twt, idx = nil)
      idx = pad(idx) if idx
      text = deentitize(twt.text)
      if config.colors?
        buf = idx ? "#{idx.cyan}:" : ""
        if twt.user.screen_name == config.account_name.to_s
          buf += "#{twt.user.screen_name.bold.blue}: #{text}"
        elsif text.mentions?(config.account_name)
          buf += "#{twt.user.screen_name.bold.red}: #{text}"
        else
          buf += "#{twt.user.screen_name.bold.cyan}: #{text}"
        end
      else
        buf = idx ? "#{idx}: " : ""
        buf += "#{twt.user.screen_name}: #{text}"
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
