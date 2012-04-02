module Fixtures
  module Migrations
    extend self

    def pre_v1
      { :rich0H =>
        { oauth_token: "I'mtotallyatokenbrah",
          oauth_token_secret: "I'mtotallyasecretbrah",
          endpoint: :twitter
        } }
    end
  end
end
