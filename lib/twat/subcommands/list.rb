module Twat::Subcommands
  class List < Base

    def run
      twitter_auth
      Twitter.home_timeline(:count => @argv[0] || 5).reverse.each do |tweet|
        format(tweet)
      end
    end

    def usage
      puts "Usage: twat list [count]"
    end

  end
  COMMANDS['list'] = List
end
