module Twat
  class Actions

    def show
      twitter_auth
      Twitter.home_timeline(:count => opts[:count]).reverse.each do |tweet|
        format(tweet)
      end
    end

  end
end
