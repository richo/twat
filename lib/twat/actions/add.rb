module Twat
  class Actions

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
      reader.puts_above "Please authenticate the application at #{token_request.authorize_url} , then enter pin"
      pin = reader.get_line
      begin
        access_token = token_request.get_access_token(oauth_verifier: pin)
        account_settings = {
          oauth_token: access_token.token,
          oauth_token_secret: access_token.secret,
          endpoint: opts[:endpoint]
        }
        config.create_unless_exists!
        config.accounts[opts[:account]] = account_settings
        config.save!
      rescue OAuth::Unauthorized
        reader.puts_above "Couldn't authenticate you, did you enter the pin correctly?"
      end
    end

  end
end