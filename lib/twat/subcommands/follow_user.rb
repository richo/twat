module Twat::Subcommands
  class FollowUser < Base

    def run
      twitter_auth

      Twitter.follow(opts[:user])
    end

  end
end

