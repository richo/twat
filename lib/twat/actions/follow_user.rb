module Twat
  class Actions

    def follow_user
      twitter_auth

      Twitter.follow(opts[:user])
    end

  end
end
