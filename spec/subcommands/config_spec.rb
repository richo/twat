require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should bail if config already exists" do #{{{
    with_config(Fixtures::multiuser_config) do
      STDOUT.expects(:puts).with(Twat::Exceptions::AlreadyConfigured.new.msg)
      set_argv ["config"]
      Twat::Twat.new.cli_run
    end
  end #}}}

end
