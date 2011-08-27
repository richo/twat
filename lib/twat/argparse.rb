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
        opts.on('-n', '--account ACCOUNT', 'Tweet from ACCOUNT (or default)') do |acct|
          options[:account] = acct.to_sym
        end
        opts.on('-a', '--add ACCOUNT', 'Configure and authorise ACCOUNT') do |acct|
          options[:account] = acct.to_sym
          options[:action] = :add
        end
        opts.on('-d', '--delete ACCOUNT', 'Delete ACCOUNT') do |acct|
          options[:account] = acct.to_sym
          options[:action] = :delete
        end
        #opts.on( '-a' '--add ACCOUNT' ) do |acct|
        #end
        opts.on('-h', '--help', 'Display this screen') do
          puts opts
          exit
        end
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
      @configthingfucken ||= getopts
    end

  end
end
