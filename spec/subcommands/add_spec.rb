require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  it "Should bail if add is called without an argument" do #{{{
    set_argv ["add"]
    STDOUT.expects(:puts).with(Twat::Subcommands::Add.usage)

    lambda { Twat::Twat.new.cli_run }.should raise_error SystemExit
  end

  it "Should create a config file if one does not already exist" do #{{{
    valid_config =  { accounts: {
        "rich0H" =>
          { oauth_token: "I'mtotallyatokenbrah",
            oauth_token_secret: "I'mtotallyasecretbrah",
            endpoint: :twitter
          } } }

    FileUtils.mktemp do |dir|
      set_env('TWAT_CONFIG' => "#{dir}/twatrc") do
        # stub out the io

        STDOUT.expects(:puts).with("Please authenticate the application at #{STUB_URL}, then enter pin")
        STDIN.expects(:gets).returns(STUB_PIN)

#{{{ Create mock opts and config
        mock_opts = mock()
        mock_opts.expects(:[]).with(:account).returns("rich0H")
#}}}

        # Stub out any oauth calls that talk externally

        OAuth::Consumer.any_instance.expects(:get_request_token).returns(mock_request_token)
        Twat::Endpoints::Twitter.any_instance.stubs(:opts).returns(mock_opts)

        set_argv ["add", "rich0H"]

        Twat::Twat.new.cli_run

        YAML.load_file(ENV['TWAT_CONFIG']).should == valid_config
      end
    end
  end

end
