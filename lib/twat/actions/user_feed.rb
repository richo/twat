module Twat
  class Actions

    def user_feed
      twitter_auth

      begin
        Twitter.user_timeline(opts[:user], :count => opts[:count]).each do |tweet|
          format(tweet)
        end
      rescue Twitter::NotFound
        puts "#{opts[:user].bold.red} doesn't appear to be a valid user"
      end
    end

  end
end
