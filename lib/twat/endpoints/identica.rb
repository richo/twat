module Twat::Endpoints
  class Identica

    def url
      "https://identi.ca/api"
    end

    def consumer_info
      {
        consumer_key: "0af040d41599f5d07b738fc90a487af7",
        consumer_secret: "b6bb7284eaf975ab65a2dd3eb53fbf3d"
      }
    end

    def oauth_options
      {
        request_token_url: "https://identi.ca/api/oauth/request_token",
        access_token_url: "https://identi.ca/api/oauth/access_token",
        authorize_url: "https://identi.ca/api/oauth/authorize"
      }
    end

  end
end
