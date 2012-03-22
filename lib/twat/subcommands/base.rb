module Twat::Subcommands
  COMMANDS = {}
  class Base

    include ::Twat::Exceptions

    attr_reader :opts

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

    def pad(n)
      "%02d" % n
    end

    # Format a tweet all pretty like
    def readline_format(twt, idx = nil)
      idx = pad(idx) if idx
      text = deentitize(twt.text)
      if config.colors?
        buf = idx ? "#{idx.cyan}:" : ""
        if twt.user.screen_name == config.account_name.to_s
          buf += "#{twt.user.screen_name.bold.blue}: #{text}"
        elsif text.mentions?(config.account_name)
          buf += "#{twt.user.screen_name.bold.red}: #{text}"
        else
          buf += "#{twt.user.screen_name.bold.cyan}: #{text}"
        end
      else
        buf = idx ? "#{idx}: " : ""
        buf += "#{twt.user.screen_name}: #{text}"
      end
    end


    def deentitize(text)
      {"&lt;" => "<", "&gt;" => ">", "&amp;" => "&", "&quot;" => '"' }.each do |k,v|
        text.gsub!(k, v)
      end
      text
    end

    def config
      @config ||= ::Twat::Config.new(args)
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
