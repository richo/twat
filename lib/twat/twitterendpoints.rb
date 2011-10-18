module Twat
  class TwitterEndpoints
    def new(endpoint)
      @endpoint = endpoint
    end

    def token_endpoint
      { :twitter => "twitter endpoint",
        :"identi.ca" => "identi.ca endpoint"
      }[@endpoint]
    end

  end
end
