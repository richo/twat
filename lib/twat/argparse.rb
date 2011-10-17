module Twat
  REQUIRED = []
  MSG_REQUIRED = [:tweet]

  class ArgParse

    # TODO delegate specifically instead of shimming everything?

    def usage(additional=nil)
      puts additional if additional
      puts @optparser
      exit
    end

    def getopts
      options = Hash.new
      options[:count] = 1
      @optparser = OptionParser.new do |opts|
        opts.banner = "Usage: twat <tweet>"

        opts.on('-n', '--account ACCOUNT', 'Use ACCOUNT (or default)') do |acct| #{{{ --account ACCOUNT
          options[:account] = acct.to_sym
        end # }}}
        opts.on('-a', '--add ACCOUNT', 'Configure and authorise ACCOUNT') do |acct| #{{{ --add ACCOUNT
          options[:account] = acct.to_sym
          options[:action] = :add
        end #}}}
        opts.on('--endpoint ENDPOINT', 'Specify a different endpoint for use with --add') do |endpoint| #{{{ --add ACCOUNT
          options[:endpoint] = endpoint.to_sym
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
          options[:action] ||= :show
        end #}}}
        opts.on('-f', '--follow', 'Display tweets from your newsfeed indefinitely') do #{{{ --follow
          options[:action] = :follow
        end #}}}
        opts.on('-v', '--version', 'Display version info') do #{{{ --version
          options[:action] = :version
        end #}}}
        opts.on('-u', '--user [USER]', 'Display current status for USER (Defaults to your default account)') do |user| #{{{ --user USER
          options[:user] = (user || :default)
          options[:action] = :user_feed
        end #}}}
        opts.on("--set OPTION=VALUE", 'Set OPTION to VALUE') do |optval| #{{{ --set OPTION=VALUE
          options[:action] = :setoption
          options[:optval] = optval
        end #}}}
        opts.on("--update-config", "Update config to latest version") do #{{{ --update-config
          options[:action] = :updateconfig
        end #}}}
      end
      @optparser.parse!
      # {{{ Validation ---
      # Default action is to send a tweet
      options[:action] ||= :tweet

      # Only specify an endpoint when adding accounts
      if options[:endpoint]
        usage unless options[:action] == :add
      end
      # Similarly, default endpoint to twitter when we do add
      if options[:action] == :add
        options[:endpoint] ||= :twitter
      end

      REQUIRED.each do |req|
        usage unless options[req]
      end
      if MSG_REQUIRED.include?(options[:action])
        options[:msg] = msg
      end
      # }}} Validation End ---
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
