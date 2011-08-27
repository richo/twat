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
        opts.banner = "Usage: #{$0} -a ACCOUNT <tweet>"
        opts.on('-n', '--account ACCOUNT', 'Tweet from ACCOUNT') do |acct|
          options[:account] = acct.to_sym
        end
        opts.on('-a', '--add ACCOUNT', 'Configure and authorise ACCOUNT') do |acct|
          options[:account] = acct.to_sym
          options[:action] = :add
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
