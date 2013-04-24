module ::Twitter
  class Status
    def as_user
      begin
        user.screen_name
      rescue NoMethodError
        from_user
      end
    end
  end
end

module Twat::Subcommands
  COMMANDS = {}
  class Base

    include ::Twat::Exceptions

    def initialize(argv)
      @argv=argv
    end

    def run!
      with_handled_exceptions(args) do
        run
      end
    end

    def needs_arguments(n)
      unless @argv.length == n
        usage_and_exit!
      end
    end

    def needs_at_least(n)
      unless @argv.length >= n
        usage_and_exit!
      end
    end

    def usage_and_exit!
      usage
      exit
    end

    def auth!
      Twitter.configure do |twit|
        config.account.each do |key, value|
          twit.send("#{key}=", value)
        end
        config.endpoint.consumer_info.each do |key, value|
          twit.send("#{key}=", value)
        end
      end
    end

    def beep
      print "\a"
    end

    def pad(n)
      "%02d" % n
    end

    # Format a tweet all pretty like
    def format(twt, idx = nil)
      idx = pad(idx) if idx
      text = deentitize(twt.text)
      if config.colors?
        buf = idx ? "#{idx.cyan}:" : ""
        if twt.as_user == config.account_name.to_s
          buf += "#{twt.as_user.bold.blue}: #{text}"
        elsif text.mentions?(config.account_name)
          buf += "#{twt.as_user.bold.red}: #{text}"
        else
          buf += "#{twt.as_user.bold.cyan}: #{text}"
        end
        buf.colorise!
      else
        buf = idx ? "#{idx}: " : ""
        buf += "#{twt.as_user}: #{text}"
      end
    end

    def deentitize(text)
      {"&lt;" => "<", "&gt;" => ">", "&amp;" => "&", "&quot;" => '"' }.each do |k,v|
        text.gsub!(k, v)
      end
      text
    end

    def config
      @config ||= ::Twat::Config.new
    end

    def opts
      @opts ||= ::Twat::Options.new
    end

    def args
      # This is dangerous, but realistically I don't see how else to parse the
      # args before creating an instance of a subclass
      @args ||= $args
    end

    def enable_readline!
      @reader = ReadlineNG::Reader.new
    end

    def reader
      @reader
    end

    def usage
      puts self.class.usage
    end

  end
end
