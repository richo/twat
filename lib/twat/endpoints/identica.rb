module Twat::Endpoints
  class Identica

    def initialize
      ::Twitter::Request.module_eval do
        def request(method, path, params, options)
          # Needs original method body, seems to be impossible to call original
          # implementation
          # FIXME subclass the whole show?
          path.gsub!(%r|^1/|, '')
          response = connection(options).send(method) do |request|
            case method.to_sym
            when :get, :delete
              request.url(formatted_path(path, options), params)
            when :post, :put
              request.path = formatted_path(path, options)
              request.body = params unless params.empty?
            end
          end
          options[:raw] ? response : response.body
        end
      end
    end

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
