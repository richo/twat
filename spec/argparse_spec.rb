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
    FileUtils.mktemp do |dir|
      set_env('TWAT_CONFIG' => "#{dir}/twatrc") do
        File.open("#{dir}/twatrc", 'w') do |conf|
          conf.chmod(0600)
          conf.puts(MULTIUSER_CONFIG.to_yaml)
        end

        set_argv ["-n", "secondAccount"]

        $args = ::Twat::Args.new
        conf = ::Twat::Config.new

        conf.account.should == MULTIUSER_CONFIG[:accounts][:secondAccount]
      end
    end
  end

end
