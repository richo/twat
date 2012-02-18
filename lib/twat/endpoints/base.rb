module Twat::Endpoints
  class Base

    @@endpoint_set=nil

    def authorize_account(name)
      oauth_conf = oauth_options.merge ({ :site => url })

      oauth = OAuth::Consumer.new(consumer_info[:consumer_key], consumer_info[:consumer_secret] oauth_conf])
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

  end
end
