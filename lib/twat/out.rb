module Twat
  class Out
    # FIXME -> symbols?
    COLORS = %w[normal red green yellow blue cyan] # TODO

    STATES = {  bold: 1,
                underline: 2,
                reverse: 4
    }


    # Valid invocations
    # Out.green.bold "text here"
    #
    # Out "Text here"
    #
    # Out.bold.cyan "text here"
    #
    # Out.bold.cyan do |o|
    #   o "text here"
    # end
    #
    # Out.cyan do |o|
    #   o.bold "text here"
    # end
    #
    # This ought to be the first thing I test because it's so linear

    def new(*args, &block)
      # Define where the output should go, workout the IO protocol
      @opts = Hash.new
      @opts[:color] = "normal"
      @opts[:state] = 0
    end

    def method_missing(sym, *args, &block)
      if COLORS.include?sym.to_s
        @opts[:color] = sym.to_s
      end

      if args.any?
        put args
      elsif block_given?
        yield self
      else
        self
      end
    end

    def put
      puts "Spitting out #{@opts[:color]} in #{@opts[:state]}"
    end

  end
end


