module Twat::Subcommands
  class Add < Base

    def initialize
    end

    def run
      twitter_auth

      raise TweetTooLong if opts.msg.length > 140

      Twitter.update(opts.msg)
      #puts opts.msg
    end

  end
  COMMANDS['update'] = Add
end
