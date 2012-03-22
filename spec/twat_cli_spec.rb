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

  it "Should call follow tag by default" do #{{{
    Twat::Subcommands::FollowTag.any_instance.expects(:run).returns(nil)

    set_argv []
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call follow when invoked with follow" do #{{{
    Twat::Subcommands::Follow.any_instance.expects(:run).returns(nil)

    set_argv ["follow", "rich0H"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call add when invoked with add" do #{{{
    Twat::Subcommands::Add.any_instance.expects(:run).returns(nil)

    set_argv ["add", "rich0H"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call config when invoked with config" do #{{{
    Twat::Subcommands::Config.any_instance.expects(:run).returns(nil)

    set_argv ["config"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call delete when invoked with delete" do #{{{
    Twat::Subcommands::Delete.any_instance.expects(:run).returns(nil)

    set_argv ["delete", "rich0H"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call finger when invoked with finger" do #{{{
    Twat::Subcommands::Finger.any_instance.expects(:run).returns(nil)

    set_argv ["finger"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call follow_tag when invoked with follow_tag" do #{{{
    Twat::Subcommands::FollowTag.any_instance.expects(:run).returns(nil)

    set_argv ["follow_tag"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call list when invoked with list" do #{{{
    Twat::Subcommands::List.any_instance.expects(:run).returns(nil)

    set_argv ["list"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call set when invoked with set" do #{{{
    Twat::Subcommands::Set.any_instance.expects(:run).returns(nil)

    set_argv ["set", "key", "value"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call update when invoked with update" do #{{{
    Twat::Subcommands::Update.any_instance.expects(:run).returns(nil)

    set_argv ["update", "status goes here"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call update_config when invoked with update_config" do #{{{
    Twat::Subcommands::UpdateConfig.any_instance.expects(:run).returns(nil)

    set_argv ["update_config"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call version when invoked with version" do #{{{
    Twat::Subcommands::Version.any_instance.expects(:run).returns(nil)

    set_argv ["version"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call update when no other command matches" do #{{{
    Twat::Subcommands::Update.any_instance.expects(:run).returns(nil)

    set_argv ["this", "is", "a", "tweet"]
    Twat::Twat.new.cli_run
  end #}}}
end
