module Twat::Subcommands
  class FollowUser < Base

    def run
      needs_arguments(1)
      twitter_auth

      Twitter.follow(@argv[0])
    end

  end
  COMMANDS['follow'] = FollowUser
end

