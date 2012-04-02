require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should search recent mentions" do #{{{
    with_config(Fixtures::multiuser_config) do
      Twitter.expects(:mentions)
      Twat::Subcommands::Mentions.any_instance.expects(:untested).returns(false).at_least_once
      set_argv ["mentions"]

      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should bail if called with arguments" do #{{{
    with_config(Fixtures::multiuser_config) do
      STDOUT.expects(:puts).with(Twat::Subcommands::Mentions.usage)
      set_argv ["mentions", "rawr"]

      lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
    end
  end #}}}

end
