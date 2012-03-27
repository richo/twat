require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should bail if called without a config file" do
    with_no_config do
      set_argv ["update_config"]
      STDOUT.expects(:puts).with(Twat::Exceptions::NoConfigFile.new.msg)

      Twat::Twat.new.cli_run
    end
  end #}}}

  it "Should migrate a pre-v1 config to v1" do
    with_config(Fixtures::Migrations::pre_v1) do
      STDOUT.expects(:puts).with("Successfully ran migrations: 1")
      set_argv ["update_config"]
      Twat::Twat.new.cli_run

      YAML.load_file(ENV['TWAT_CONFIG']).should == { accounts: Fixtures::Migrations::pre_v1 }
    end
  end #}}}
end
