module Twat
  REQUIRED = []
  MSG_REQUIRED = [:tweet]
  class ArgWrapper
    def initialize(data)
      @data = data
    end

    def method_missing(sym)
      @data[sym]
    end
  end

  class ArgParse

    # TODO delegate specifically instead of shimming everything?
    # TODO Twat::Subcommands.COMMANDS needs to be parsed and dumped

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
        opts.on('--endpoint ENDPOINT', 'Specify a different endpoint for use with --add') do |endpoint| #{{{ --add ACCOUNT
          options[:endpoint] = endpoint.to_sym
        end #}}}
        opts.on('-h', '--help', 'Display this screen') do #{{{ --help
          puts opts
          exit
        end #}}}
        opts.on('-v', '--version', 'Display version info') do #{{{ --version
          options[:action] = :version
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
      ArgWrapper.new(options)
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
