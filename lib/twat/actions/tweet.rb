module Twat
  class Actions

    def tweet
      twitter_auth

      raise TweetTooLong if opts.msg.length > 140

      Twitter.update(opts.msg)
      #puts opts.msg
    end

  end
end
