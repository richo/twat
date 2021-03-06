require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should bail if add is called without an argument" do #{{{
    set_argv ["add"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Add.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end #}}}

  it "Should create a config file if one does not already exist" do #{{{
    FileUtils.mktemp do |dir|
      set_env('TWAT_CONFIG' => "#{dir}/twatrc") do
        # stub out the io

        STDOUT.expects(:puts).with("Please authenticate the application at #{STUB_URL}, then enter pin")
        STDIN.expects(:gets).returns(STUB_PIN)

        # Stub out any oauth calls that talk externally

        OAuth::Consumer.any_instance.expects(:get_request_token).returns(mock_request_token)

        set_argv ["add", "rich0H"]

        Twat::Twat.new.cli_run

        YAML.load_file(ENV['TWAT_CONFIG']).should == Fixtures::valid_config
      end
    end
  end #}}}

  it "Should call the twitter endpoint if specified" do #{{{
    Twat::Endpoints::Twitter.any_instance.expects(:authorize_account)

    set_argv ["--endpoint", "twitter", "add", "rich0H"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call the identi.ca endpoint if specified" do #{{{
    Twat::Endpoints::Identica.any_instance.expects(:authorize_account)

    set_argv ["--endpoint", "identi.ca", "add", "rich0H"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should call the twitter endpoint by default" do #{{{
    Twat::Endpoints::Twitter.any_instance.expects(:authorize_account)

    set_argv ["add", "rich0H"]
    Twat::Twat.new.cli_run
  end #}}}

  it "Should fail if asked for an invalid endpoint" do #{{{
    STDOUT.expects(:puts).with(Twat::Exceptions::NoSuchEndpoint.new.msg)

    set_argv ["--endpoint", "rawk", "add", "rich0H"]
    Twat::Twat.new.cli_run
  end #}}}

end
