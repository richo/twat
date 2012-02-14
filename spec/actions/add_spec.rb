require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Twat::Actions do
  describe "Add" do
    it "should create config file if it doesn't exist" do
      PIN = 1234
      ACCESS_TOKEN = mock()
      ACCESS_TOKEN.expects(:token).returns("token")
      ACCESS_TOKEN.expects(:secret).returns("secret")

      ENV['HOME'] = mktmpdir

      oauth_token = mock()
      oauth_token.expects(:get_access_token).with(PIN).returns(ACCESS_TOKEN)
      OAuth::Consumer.expects(:new).returns(oauth_token)

      add = Twat::Actions.new
      add.opts = get_opts
      add.add
    end
  end
end
