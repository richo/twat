require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FollowMixin do

  it "Should not retweet users with numbers for usernames" do
    # 58 seems to be a magic number
    subcmd = Twat::Subcommands::FollowTag.new([])
    def subcmd.tweetstack
      @tweetstack ||= ::Twat::TweetStack.new
    end

    # We start tweetstack offsets at 1 for easy readability
    (1..60).each { |n| subcmd.tweetstack << Twat::Mocks::Tweet.new(:id => n) }

    Twitter.expects(:retweet).with(10058)
    subcmd.send(:process_input, "rt 58")
  end

end
