module Twat::Subcommands
  class User < Base

    def run
      raise ArgumentRequired if @argv.length == 0
      twitter_auth

      begin
        Twitter.user_timeline(@argv[0], :count => @argv[1] || 1).each do |tweet|
          format(tweet)
        end
      rescue Twitter::NotFound
        puts "#{@argv[0].bold.red} doesn't appear to be a valid user"
      end
    end

  end
  COMMANDS['user'] = User
end
