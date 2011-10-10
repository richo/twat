module Twat
  class Out
    @@dest = STDOUT
    COLORS = {  normal: "[39m%s[39m",
                black:    "[30m%s[39m",
                red:    "[31m%s[39m",
                green:    "[32m%s[39m",
                yellow:    "[33m%s[39m",
                blue:    "[34m%s[39m",
                magenta:    "[35m%s[39m",
                cyan:    "[36m%s[39m",
                bold:    "[1m%s[0m",
    }

    def self.method_missing(sym, *args, &block)
      Out.new.send(sym, *args, &block)
    end

    # Valid invocations
    # Out.green.bold "text here"
    #
    # Out "Text here"
    #
    # Out.cyan.bold "text here"
    #
    # Out.cyan.bold do |o|
    #   o.put "text here"
    # end
    #
    # Out.cyan do |o|
    #   o.bold "text here"
    # end
    #
    # This ought to be the first thing I test because it's so linear

    def method_missing(sym, *args, &block)
      if args.any?
        @color = @color ? format(@color, color?(sym)) : color?(sym)
        put format(@color, args[0])
        @color = nil
      elsif block_given?
        @color = color?(sym)
        yield self
        @color = nil
      else
        @color = color?(sym)
        self
      end
    end

    def dest=(dest)
      @@dest=dest
    end

    def self.dest=(dest)
      @@dest=dest
    end

    private

    def put(data)
      data = format(@color, data) if @color
      @@dest.puts data
    end

    def print(data)
      data = format(@color, data) if @color
      @@dest.print data
    end

    def color?(sym)
      begin
        return config.colors? ? COLORS[sym] : "%s"
      rescue TypeError
        raise InvalidColor
      rescue NoConfigFile
        COLORS[sym]
      end
    end

    def config
      @config ||= Config.new
    end

  end
end


