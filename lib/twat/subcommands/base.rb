module Twat::Subcommands
  COMMANDS = {}
  class Base

    attr_reader :opts

    def initialize(argv)
      @argv=argv
      @opts = ::Twat::ArgParse.new.getopts
    end

    def twitter_auth
      Twitter.configure do |twit|
        config.account.each do |key, value|
          twit.send("#{key}=", value)
        end
        config.endpoint.consumer_info.each do |key, value|
          twit.send("#{key}=", value)
        end
        twit.endpoint = config.endpoint.url
      end
    end

    def beep
      print "\a"
    end

    # Format a tweet all pretty like
    def format(twt)
      text = deentitize(twt.text)
      if config.colors?
        if twt.user.screen_name == config.account_name.to_s
          puts "#{twt.user.screen_name.bold.blue}: #{text}"
        elsif text.mentions?(config.account_name)
          puts "#{twt.user.screen_name.bold.red}: #{text}"
        else
          puts "#{twt.user.screen_name.bold.cyan}: #{text}"
        end
      else
        puts "#{twt.user.screen_name}: #{text}"
      end
    end

    def deentitize(text)
      {"&lt;" => "<", "&gt;" => ">", "&amp;" => "&", "&quot;" => '"' }.each do |k,v|
        text.gsub!(k, v)
      end
      text
    end

    def config
      ::Twat::Twat.config
    end

  end
end
