require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

MULTIUSER_CONFIG = { accounts: {
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

describe Twat do

  it "Should respect the -n flag" do
    with_config(MULTIUSER_CONFIG) do

      set_argv ["-n", "secondAccount"]

      $args = ::Twat::Args.new
      conf = ::Twat::Config.new

      conf.account.should == MULTIUSER_CONFIG[:accounts][:secondAccount]
    end
  end

  it "Should respect the --account flag" do
    with_config(MULTIUSER_CONFIG) do

      set_argv ["--account", "secondAccount"]

      $args = ::Twat::Args.new
      conf = ::Twat::Config.new

      conf.account.should == MULTIUSER_CONFIG[:accounts][:secondAccount]
    end
  end

end
