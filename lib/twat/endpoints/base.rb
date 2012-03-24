module Twat::Endpoints
  class Base

    @@endpoint_set=nil

    def authorize_account(name)
      oauth_conf = oauth_options.merge ({ :site => url })

      OauthProxy.proxy do |proxy|
        oauth = OAuth::Consumer.new(consumer_info[:consumer_key], consumer_info[:consumer_secret], oauth_conf)
        token_request = oauth.get_request_token( oauth_callback: "http://oauth.psych0.tk/callback/#{proxy.get_id}")
        Launchy.open(token_request.authorize_url)
        access_token = token_request.get_access_token(oauth_verifier: proxy.get_secret)
        account_settings = {
          oauth_token: access_token.token,
          oauth_token_secret: access_token.secret,
          endpoint: endpoint_name
        }
        config.accounts[name.to_sym] = account_settings
        config.save!
      end
    end

    def config
      return @config if @config
      @config = ::Twat::Config.new
      @config.create! unless @config.exists?
      return @config
    end

    def endpoint_name
      raise "Endpoint not set! Naughty programmer"
    end

  end
end
