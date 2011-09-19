module Twat
  OAUTH_TOKENS = [ :oauth_token, :oauth_token_secret ]
  CONSUMER_TOKENS = [ :consumer_key, :consumer_secret ]
  class Actions

    def tweet(opts)
      # This is all broken, we should know what options we have before this happend
      conf = cf[opts[:account]]

      Twitter.configure do |twit|
        conf.each do |key, value|
          twit.send("#{key}=", value)
        end
        Config.consumer_info.each do |key, value|
          twit.send("#{key}=", value)
        end
      end

      Twitter.update(opts.msg)
      #puts opts.msg
    end

    def add(opts)
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
        cf[opts[:account]] = {
          oauth_token: access_token.token,
          oauth_token_secret: access_token.secret
        }
        cf.save! 
      rescue OAuth::Unauthorized
        puts "Couldn't authenticate you, did you enter the pin correctly?"
      end
    end

    def delete(opts)
      if cf.delete(opts[:account])
        cf.save!
        puts "Successfully deleted"
      else
        puts "No such account"
      end
    end

    def version(opts)
      puts "twat: #{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"
    end

    private

    def cf
      @cf ||= Config.new
    end

  end
end
