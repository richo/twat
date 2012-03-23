require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should search home_timeline when called sans args" do #{{{
    Twitter.expects(:home_timeline)
    Twat::Subcommands::FollowTag.any_instance.expects(:untested).returns(false).at_least_once
    set_argv []

    # lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
    Twat::Twat.new.cli_run
  end #}}}

  it "Should search home_timeline when called as follow_tag" do #{{{
    Twitter.expects(:home_timeline)
    Twat::Subcommands::FollowTag.any_instance.expects(:untested).returns(false).at_least_once
    set_argv ["follow_tag"]

    # lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call search with the argument if called with one" do #{{{
    mock_opts = mock()
    Twitter.expects(:search).with("#hackmelb", count: 5)
    Twat::Subcommands::FollowTag.any_instance.expects(:untested).returns(false).at_least_once
    set_argv ["follow_tag", "#hackmelb"]

    # lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
    Twat::Twat.new.cli_run
  end #}}}

  it "Should cat together all commandline args" do #{{{
    mock_opts = mock()
    Twitter.expects(:search).with("#hackmelb richo", count: 5)
    Twat::Subcommands::FollowTag.any_instance.expects(:untested).returns(false).at_least_once
    set_argv ["follow_tag", "#hackmelb", "richo"]

    # lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
    Twat::Twat.new.cli_run
  end #}}}


end
