require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should bail if finger is called without an argument" do #{{{
    with_config(Fixtures::multiuser_config) do
      set_argv ["finger"]
      STDOUT.expects(:puts).with(Twat::Subcommands::Finger.usage)

      lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
    end
  end #}}}

  it "Should retrieve a tweet for user if called with only a user" do #{{{
    with_config(Fixtures::multiuser_config) do
      tweet = mock()
      tweet.expects(:each).yields(tweet)
      Twitter.expects(:user_timeline).with("hanke", :count => 1).returns(tweet)
      Twat::Subcommands::Finger.any_instance.expects(:format).with(tweet)

      set_argv ["finger", "hanke"]

      STDOUT.expects(:puts)
      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should retrieve n tweets for user if invoked with count" do #{{{
    with_config(Fixtures::multiuser_config) do
      tweet = mock()
      Twitter.expects(:user_timeline).with("hanke", :count => 3).returns([tweet, tweet, tweet])
      Twat::Subcommands::Finger.any_instance.expects(:format).with(tweet).times(3)

      set_argv ["finger", "hanke", "3"]

      STDOUT.expects(:puts).times(3)
      Twat::Twat.new.cli_run
    end
  end #}}}

end
