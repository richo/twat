module Twat::Subcommands
  class Update < Base

    def run
      twitter_auth

      raise TweetTooLong if opts.msg.length > 140

      Twitter.update(opts.msg)
      #puts opts.msg
    end

  end
  COMMANDS['update'] = Update
end
