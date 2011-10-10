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
        put format(color?(sym), args[0])
      elsif block_given?
        @color = color?(sym)
        puts @color
        yield self
        @color = nil
      else
        self
      end
    end

    def put(data)
      data = format(@color, data) if @color
      @@dest.puts data
    end

    def dest=(dest)
      @@dest=dest
    end

    def self.dest=(dest)
      @@dest=dest
    end

    private

    def color?(sym)
      begin
        COLORS[sym]
      rescue TypeError
        raise InvalidColor
      end
    end

  end
end


