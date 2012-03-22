require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should bail if set is called without an argument" do #{{{
    set_argv ["set"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Set.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end

  it "Should bail if set is called with only one argument" do #{{{
    set_argv ["set", "key"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Set.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end

  it "Should bail if set is called with more than two arguments" do #{{{
    set_argv ["set", "key", "value", "junk"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Set.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end

end
