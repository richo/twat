module Twat

  %w[base twitter identica].each do |filename|
    require File.join(File.expand_path("../endpoints", __FILE__), filename)
  end

  ENDPOINTS = ["identi.ca", "twitter"]

  # Proxies to the actual endpoint classes
  class Endpoint
    def self.new(endpoint)
      begin
        @implementation = {
          :twitter => Endpoints::Twitter,
          :"identi.ca" => Endpoints::Identica
        }[endpoint].new
      rescue NoMethodError
        raise Exceptions::NoSuchEndpoint
      end
    end
  end
end
