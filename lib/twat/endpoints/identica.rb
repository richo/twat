module Twat::Endpoints
  class Identica

    def initialize
      ::Twitter::Request.module_eval do
        alias :_request :request
        def request(method, path, params, options)
          path.gsub!(%r|^1/|, '')
          _request(method, path, params, options)
        end
      end
    end

    # this bails with /home/richo/code/ext/twat/lib/twat/endpoints/identica.rb:6:in `block in initialize': uninitialized constant Twat::Endpoints::Identica::Request (NameError)
    # So I figured it's still relative to This module, so I tried
    #
    # ::Twitter.module_eval...

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
