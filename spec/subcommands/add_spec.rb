require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should bail if add is called without an argument" do #{{{
    set_argv ["add"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Add.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end

  it "Should create a config file if one does not already exist" do #{{{
    FileUtils.mktemp do |dir|
      set_env('TWAT_CONFIG' => "#{dir}/twatrc") do
        puts ENV.inspect
        set_argv ["add", "rich0H"]

        Twat::Twat.new.cli_run
      end
    end
  end

end
