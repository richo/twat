module Fixtures
  extend self

  def multiuser_config
    { accounts: {
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
  end

  def valid_config
    { accounts: {
      :rich0H =>
      { oauth_token: "I'mtotallyatokenbrah",
        oauth_token_secret: "I'mtotallyasecretbrah",
        endpoint: :twitter
      } } }
  end

end
