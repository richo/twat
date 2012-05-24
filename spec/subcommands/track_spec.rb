require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do
  it "should work when called without config" do
    set_argv ["track", "rich0H"]
    Twat::Subcommands::Track.any_instance.expects(:untested).returns(false).at_least_once
    Twitter.expects(:user_timeline).with("rich0H", {:count => 5})

    Twat::Twat.new.cli_run
  end

  it "Should respect config when called with" do
    with_config(Fixtures::multiuser_config) do
      set_argv ["track", "rich0H"]

      Twat::Subcommands::Track.any_instance.expects(:untested).returns(false).at_least_once
      Twitter.expects(:user_timeline).with("rich0H", {:count => 5})

      Twat::Twat.new.cli_run
    end
  end

end
