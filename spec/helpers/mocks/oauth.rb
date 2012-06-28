STUB_URL = "url"
STUB_PIN = "1234"
def mock_request_token
  t = ::Mocha::Mock.new(Object)
  t.expects(:authorize_url).returns(STUB_URL)
  t.expects(:get_access_token).with(oauth_verifier: STUB_PIN).returns(mock_access_token)
  return t
end

def mock_access_token
  t = ::Mocha::Mock.new(Object)
  t.expects(:token).returns("I'mtotallyatokenbrah")
  t.expects(:secret).returns("I'mtotallyasecretbrah")
  return t
end
