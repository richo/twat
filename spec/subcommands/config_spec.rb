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

  # it "Should bail if config already exists" do #{{{
  #   with_config(multiuser_config) do
  #     set_argv ["config"]
  #   end
  # end

end
