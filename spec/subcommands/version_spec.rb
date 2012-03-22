require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should bail if add is called without an argument" do #{{{
    set_argv ["add"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Add.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end

end
