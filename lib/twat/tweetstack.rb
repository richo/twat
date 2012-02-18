module Twat
  class TweetStack
    # A circularly linked list representing all of the tweets printed thus far,
    # for the purposes of retrieving them after being printed
    def initialize
      @stack = {}
      @_next = 0
    end

    def [] k
      @stack[k]
    end

    def << v
      @stack[nxt] = v
    end

    def include? k
      @stack.keys.include?(k)
    end

    def last
      # I see the irony
      @_next
    end

    private

    def nxt
      if @_next == 99
        @_next = 1
      else
        @_next += 1
      end
    end

  end
end
