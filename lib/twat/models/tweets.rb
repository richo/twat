module Twat
  module Models
    class Tweets

      def initialize(sym, opts={})
        @sym = sym
        @default = opts
      end

      def raw(opts)
        fetch(@sym, opts)
      end


      def new_tweets
        fetch @default.merge(:since => last_id)
      end

      private

      def fetch(opts)
        twts = Twitter.send(@sym, opts)
        last_id = twts[-1].id
        return twts
      end

    end
  end
end
