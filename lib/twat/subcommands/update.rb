module Twat::Subcommands
  class Update < Base

    def run
      msg = @argv.join(" ")
      raise TweetTooLong if msg.length > 140

      auth!

      Twitter.update(msg)
      #puts msg
    end

    def self.usage
      "Usage: twat update tweet goes here"
    end

  end
  COMMANDS['update'] = Update
end
