module Twat::Subcommands
  class Update < Base

    def run
      msg = @argv.join(" ")
      raise TweetTooLong if msg.length > 140

      twitter_auth


      Twitter.update(msg)
      #puts msg
    end

  end
  COMMANDS['update'] = Update
end
