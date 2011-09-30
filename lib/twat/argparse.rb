module Twat
  REQUIRED = []
  MSG_REQUIRED = [:tweet]

  class ArgParse

    def usage(additional=nil)
      puts additional if additional
      puts @optparser
      exit
    end

    def getopts
      options = Hash.new
      @optparser = OptionParser.new do |opts|
        options[:action] = :tweet
        opts.banner = "Usage: twat <tweet>"

        opts.on('-n', '--account ACCOUNT', 'Use ACCOUNT (or default)') do |acct| #{{{ --account ACCOUNT
          options[:account] = acct.to_sym
        end # }}}
        opts.on('-a', '--add ACCOUNT', 'Configure and authorise ACCOUNT') do |acct| #{{{ --add ACCOUNT
          options[:account] = acct.to_sym
          options[:action] = :add
        end #}}}
        opts.on('-d', '--delete ACCOUNT', 'Delete ACCOUNT') do |acct| #{{{ --delete ACCOUNT
          options[:account] = acct.to_sym
          options[:action] = :delete
        end #}}}
        opts.on('-h', '--help', 'Display this screen') do #{{{ --help
          puts opts
          exit
        end #}}}
        opts.on('-l', '--list [COUNT]', 'Display [count] tweets from your newsfeed') do |count| #{{{ --list ACCOUNT
          options[:count] = count || 10
          options[:action] = :show
        end #}}}
        opts.on('-v', '--version', 'Display version info') do #{{{ --version
          options[:action] = :version
        end
        opts.on('-u', '--user [USER]', 'Display current status for USER (Defaults to your default account)') do |user| #{{{ --user USER
          options[:user] = (user || :default)
          options[:action] = :user_feed
        end #}}}
        opts.on("--set-default ACCOUNT", 'Set ACCOUNT as default') do #{{{ --set-default ACCOUNT
          options[:action] = :setdefault
          options[:account] = acct.to_sym
        end #}}}
        opts.on("--update-config", "Update config to latest version") do #{{{ --update-config
          options[:action] = :updateconfig
        end #}}}
      end

      @optparser.parse!
      REQUIRED.each do |req|
        usage unless options[req]
      end
      if MSG_REQUIRED.include?(options[:action])
        options[:msg] = msg
      end
      options
    end

    def msg
      usage unless ARGV.length > 0
      ARGV.join(" ")
    end

    def [](key)
      options[key]
    end

    def include?(key)
      options.include?(key)
    end

    def options
      begin
        @configthingfucken ||= getopts
      # FIXME, actually do something smart, not yell and barf
      rescue OptionParser::InvalidOption
        usage "Unknown option"
      rescue OptionParser::MissingArgument
        usage "Missing argument"
      end
    end

  end
end
