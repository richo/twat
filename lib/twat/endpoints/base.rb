module Twat::Endpoints
  class Base

    @@endpoint_set=nil

    def authorize_account(name)
      oauth_conf = oauth_options.merge ({ :site => url })

      oauth = OAuth::Consumer.new(consumer_info[:consumer_key], consumer_info[:consumer_secret], oauth_conf)
      token_request = oauth.get_request_token()
      puts "Please authenticate the application at #{token_request.authorize_url}, then enter pin"
      pin = STDIN.gets.chomp
      begin
        access_token = token_request.get_access_token(:oauth_verifier => pin)
        account_settings = {
          :oauth_token => access_token.token,
          :oauth_token_secret => access_token.secret,
          :endpoint => endpoint_name
        }
        config.accounts[name.to_sym] = account_settings
        config.save!
      rescue OAuth::Unauthorized
        puts "Couldn't authenticate you, did you enter the pin correctly?"
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
