require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  multiuser_config = { accounts: {
    :rich0H =>
    { oauth_token: "rich0h's token",
      oauth_token_secret: "rich0H's secret",
      endpoint: :twitter
    },
      :secondAccount =>
    { oauth_token: "secondAccount's token",
      oauth_token_secret: "secondAccount's secret",
      endpoint: :twitter
    }
  },
    :default => :rich0H
  }

  it "Should search home_timeline when called sans args" do #{{{
    with_config(multiuser_config) do
      Twitter.expects(:home_timeline)
      Twat::Subcommands::FollowTag.any_instance.expects(:untested).returns(false).at_least_once
      set_argv []

      # lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should search home_timeline when called as follow_tag" do #{{{
    with_config(multiuser_config) do
      Twitter.expects(:home_timeline)
      Twat::Subcommands::FollowTag.any_instance.expects(:untested).returns(false).at_least_once
      set_argv ["follow_tag"]

      # lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should call search with the argument if called with one" do #{{{
    with_config(multiuser_config) do
      mock_opts = mock()
      Twitter.expects(:search).with("#hackmelb", count: 5)
      Twat::Subcommands::FollowTag.any_instance.expects(:untested).returns(false).at_least_once
      set_argv ["follow_tag", "#hackmelb"]

      # lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should cat together all commandline args" do #{{{
    with_config(multiuser_config) do
      mock_opts = mock()
      Twitter.expects(:search).with("#hackmelb richo", count: 5)
      Twat::Subcommands::FollowTag.any_instance.expects(:untested).returns(false).at_least_once
      set_argv ["follow_tag", "#hackmelb", "richo"]

      # lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
      Twat::Twat.new.cli_run
    end
  end #}}}


end
