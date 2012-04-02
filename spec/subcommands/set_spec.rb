require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do


  it "Should bail if set is called without an argument" do #{{{
    set_argv ["set"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Set.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end #}}}

  it "Should bail if set is called with only one argument" do #{{{
    set_argv ["set", "key"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Set.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end #}}}

  it "Should bail if set is called with more than two arguments" do #{{{
    set_argv ["set", "key", "value", "junk"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Set.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end #}}}

  it "Should bail on valid invocations with no config" do #{{{
    with_no_config do
      set_argv ["set", "beep", "rawk"]

      STDOUT.expects(:puts).with(Twat::Exceptions::NoConfigFile.new.msg)

      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should bail when bool options are tried with bogus values" do #{{{
    with_config(Fixtures::valid_config) do
      set_argv ["set", "beep", "rawk"]
      STDOUT.expects(:puts).with(Twat::Exceptions::InvalidBool.new.msg)

      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should bail if a nonexistant account is set as default" do #{{{
    with_config(Fixtures::valid_config) do
      set_argv ["set", "default", "rawk"]
      STDOUT.expects(:puts).with(Twat::Exceptions::NoSuchAccount.new.msg)

      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should set valid accounts as default" do #{{{
    with_config(Fixtures::valid_config) do
      set_argv ["set", "default", "rich0H"]
      STDOUT.expects(:puts).with("Successfully set default as rich0H")

      Twat::Twat.new.cli_run
      YAML.load_file(ENV['TWAT_CONFIG'])[:default].should == :rich0H
    end
  end #}}}

  it "Should set a given option as show_mentions" do #{{{
    with_config(Fixtures::valid_config) do
      set_argv ["set", "show_mentions", "true"]
      STDOUT.expects(:puts).with("Successfully set show_mentions as true")

      Twat::Twat.new.cli_run
      YAML.load_file(ENV['TWAT_CONFIG'])[:show_mentions].should == true
    end
  end #}}}

  it "Should bail if non ints are given as polling intervals" do #{{{
    with_config(Fixtures::valid_config) do
      set_argv ["set", "polling_interval", "rawk"]
      STDOUT.expects(:puts).with(Twat::Exceptions::InvalidInt.new.msg)

      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should set polling interval on valid settings" do #{{{
    with_config(Fixtures::valid_config) do
      set_argv ["set", "polling_interval", "75"]
      STDOUT.expects(:puts).with("Successfully set polling_interval as 75")

      Twat::Twat.new.cli_run
      YAML.load_file(ENV['TWAT_CONFIG'])[:polling_interval].should == 75
    end
  end #}}}

  Twat::Options::BOOL_TRUE.each do |v|
    it "Should allow bool values to be set to #{v} and be considered true" do #{{{

      with_config(Fixtures::valid_config) do
        # TODO Build this message automagically
        STDOUT.expects(:puts).with("Successfully set beep as #{v}")

        set_argv ["set", "beep", v]
        Twat::Twat.new.cli_run

        YAML.load_file(ENV['TWAT_CONFIG'])[:beep].should === true
      end

    end
  end #}}}

  Twat::Options::BOOL_FALSE.each do |v|
    it "Should allow bool values to be set to #{v} and be considered true" do #{{{

      with_config(Fixtures::valid_config) do
        # TODO Build this message automagically
        STDOUT.expects(:puts).with("Successfully set beep as #{v}")

        set_argv ["set", "beep", v]
        Twat::Twat.new.cli_run

        YAML.load_file(ENV['TWAT_CONFIG'])[:beep].should === false
      end

    end
  end #}}}

end
