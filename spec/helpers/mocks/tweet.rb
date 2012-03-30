module Mocks
  class Tweet

    @@id = 1

    attr_accessor :id

    def initialize
      id = @@id + (rand * 15).to_i
      @@id = id
    end

  end

  def self.tweets(n)
    ary = []
    n.times do
      ary << Mocks::Tweet.new
    end
    ary
  end
end
