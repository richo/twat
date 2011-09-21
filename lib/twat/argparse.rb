module Twat
  REQUIRED = [:account]
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
        options[:account] = :default
        opts.banner = "Usage: twat <tweet>"

        opts.on('-n', '--account ACCOUNT', 'Tweet from ACCOUNT (or default)') do |acct| #{{{ --account ACCOUNT
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
        opts.on('-v', '--version', 'Display version info') do #{{{ --version
          options[:action] = :version
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

    def options
      begin
        @configthingfucken ||= getopts
      rescue OptionParser::InvalidOption
        usage "Unknown option"
      end
    end

  end
end
