module Twat::Subcommands
  class Base

    def initialize(argv)
      # Logic to parse argv goes here
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

  end
end
