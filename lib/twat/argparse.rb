module Twat
  class ArgWrapper
    def initialize(data)
      @data = data
    end

    def method_missing(sym)
      @data[sym]
    end
  end

  class Args
    # TODO delegate specifically instead of shimming everything?
    # TODO Twat::Subcommands.COMMANDS needs to be parsed and dumped

    def initialize
      # XXX What the shit...
      getopts
    end

    def method_missing(sym)
      @options[sym]
    end

    def [](key)
      @options[key]
    end

    def include?(key)
      @options.include?(key)
    end

    private

    def usage(additional=nil)
      puts additional if additional
      puts @optparser
      exit
    end

    def getopts
      options = Hash.new
      @optparser = OptionParser.new do |opts|
        opts.banner = "Usage: twat <tweet>"

        opts.on('-n', '--account ACCOUNT', 'Use ACCOUNT (or default)') do |acct| #{{{ --account ACCOUNT
          options[:account] = acct.to_sym
        end # }}}
        opts.on('--endpoint ENDPOINT', 'Specify a different endpoint for use with add or config') do |endpoint| #{{{ --add ACCOUNT
          options[:endpoint] = endpoint.to_sym
        end #}}}
        opts.on('-h', '--help', 'Display this screen') do #{{{ --help
          puts opts
          exit
        end #}}}
        opts.on('-v', '--version', 'Display version info') do #{{{ --version
          # FIXME, this is /bad/
          puts "twat #{::Twat::VERSION}"
          exit
        end #}}}
        opts.on("--update-config", "Update config to latest version") do #{{{ --update-config
          options[:action] = :updateconfig
        end #}}}
      end
      @optparser.parse!

      # Only makes sense for add, but doesn't hurt anything else
      options[:endpoint] ||= :twitter

      @options = options
    end

  end
end
