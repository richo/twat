module Twat
  module Models
    class Tweets

      def initialize(sym, args=[], opts={})
        @sym = sym
        @args = args
        @default = opts
      end

      def raw(opts)
        fetch(opts)
      end


      def new_tweets
        fetch(@default.merge(:since => last_id))
      end

      private

      def fetch(opts)
        twts = Twitter.send(@sym, *@args, opts)
        last_id = twts[-1].id
        return twts
      end

    end
  end
end
