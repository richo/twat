require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'twat'
require 'mocha'

describe Twat do
#{{{
  # before(:each) do
  # end

  # after(:each) do
  # end
#}}}

  it "Should call follow tag by default" do
    Twat::Subcommands::FollowTag.any_instance.expects(:run).returns(nil)

    set_argv []
    Twat::Twat.new.cli_run
  end

  it "Should call follow when invoked with follow" do
    Twat::Subcommands::Follow.any_instance.expects(:run).returns(nil)

    set_argv ["follow", "rich0H"]
    Twat::Twat.new.cli_run
  end

end
