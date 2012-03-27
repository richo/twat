require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat do

  multiuser_config = { accounts: {
    :rich0H =>
    { oauth_token: "rich0h's token",
      oauth_token_secret: "rich0H's secret",
      endpoint: :twitter
    },
      :secondAccount =>
    { oauth_token: "secondAccount's token",
      oauth_token_secret: "secondAccount's secret",
      endpoint: :twitter
    }
  },
    :default => :rich0H
  }

  it "Should bail if config already exists" do #{{{
    with_config(multiuser_config) do
      STDOUT.expects(:puts).with(Twat::Exceptions::AlreadyConfigured.new.msg)
      set_argv ["config"]
      Twat::Twat.new.cli_run
    end
  end

end
