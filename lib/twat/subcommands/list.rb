module Twat::Subcommands
  class List < Base

    def run
      twitter_auth
      Twitter.home_timeline(:count => opts[:count]).reverse.each do |tweet|
        format(tweet)
      end
    end

  end
  COMMANDS['list'] = List
end
