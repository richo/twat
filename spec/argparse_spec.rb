require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

MULTIUSER_CONFIG = { accounts: {
        :rich0H =>
          { oauth_token: "I'mtotallyatokenbrah",
            oauth_token_secret: "I'mtotallyasecretbrah",
            endpoint: :twitter
          },
        :secondAccount =>
          { oauth_token: "I'mtotallyatokenbra__h",
            oauth_token_secret: "I'mtotallyasecretbra__h",
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

end
