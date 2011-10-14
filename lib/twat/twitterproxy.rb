require 'twitter'
module Twat
  extend Twitter
  class << self
    def new(options={})
      options[:endpoint] = config.endpoint if config.endpoint
      Twitter::Client.new(options)
    end

    private

    def config
      @config ||= Config.new
    end
  end
end
