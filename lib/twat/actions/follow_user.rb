module Twat
  class Actions

    def follow_user(user = nil)
      twitter_auth

      Twitter.follow(user || opts[:user])
    end

  end
end
