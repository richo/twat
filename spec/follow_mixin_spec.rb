require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FollowMixin do

  # Give us the ability to inject arbitrary tweetstacks #{{{
  module FollowMixin
    def tweetstack=(stack)
      @tweetstack = stack
    end

    def untested
      false
    end
  end #}}}

  class TestObject
    include FollowMixin
  end

  %w[rt RT retweet].each do |verb|
    it "Should interpret #{verb} as retweet" do
      tweet_id = 10

      input = "#{verb} #{tweet_id}"

      obj = TestObject.new
      obj.expects(:retweet).with(tweet_id)

      # Call private method
      obj.send(:handle_input, input)
    end
  end

end



