require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  valid_config =  { accounts: {
    :rich0H =>
    { oauth_token: "I'mtotallyatokenbrah",
      oauth_token_secret: "I'mtotallyasecretbrah",
      endpoint: :twitter
    } } }

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

  it "Should bail if a non bool is tried for a bool option" do #{{{
    # if there's also no config, which error should be thrown?
    set_argv ["set", "beep", "rawk"]
    STDOUT.expects(:puts).with(Twat::Exceptions::InvalidBool.new.msg)

    Twat::Twat.new.cli_run
  end

  Twat::Options::BOOL_TRUE.each do |v|
    it "Should allow bool values to be set to #{v} and be considered true" do

      with_config(valid_config) do
        # TODO Build this message automagically
        STDOUT.expects(:puts).with("Successfully set beep as #{v}")

        set_argv ["set", "beep", v]
        Twat::Twat.new.cli_run

        YAML.load_file(ENV['TWAT_CONFIG'])[:beep].should === true
      end

    end

  end
end
