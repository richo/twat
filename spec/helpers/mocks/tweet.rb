module Twat::Mocks
  class Tweet
    def initialize(opts)
      @opts = opts
    end

    def id
      @opts[:id]+10000
    end

    # def method_missing(sym, *args)
    #   if opts.include? sym
    #     opts[sym]
    #   else
    #     raise "#{sym}"
    #   end
    # end
  end
end
