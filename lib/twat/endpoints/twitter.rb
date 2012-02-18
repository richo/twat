module Twat::Endpoints
  class Twitter < Base

    def url
      "https://api.twitter.com/"
    end

    def consumer_info
      {
        consumer_key: "jtI2q3Z4NIJAehBG4ntPIQ",
        consumer_secret: "H6vQOGGn9qVJJa9lWyTd2s8ZZRXG4kh3SMfvZ2uxOXE"
      }
    end

    def oauth_options
      {}
    end

  end
end


