module Twat::Subcommands
  class Finger < Base

    def run
      needs_at_least(1)
      auth!

      begin
        Twitter.user_timeline(@argv[0], :count => (@argv[1] || 1).to_i).each do |tweet|
          format(tweet)
        end
      # rescue Twitter::NotFound
      #   puts "#{@argv[0].bold.red} doesn't appear to be a valid user"
      end
    end

    def self.usage
      "Usage: twat finger USERNAME [count]"
    end

  end
  COMMANDS['finger'] = Finger
end
