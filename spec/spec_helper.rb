require 'mocha'
require 'twat'

RSpec.configure do |config|
  config.mock_with :mocha
end

def get_opts
  { endpoint: :twitter }
end

def mktmpdir
  dir = "/tmp/#{$$}-twat"
  if FileUtils.mkdir_p(dir)
    at_exit do
      FileUtils.rm_r(dir)
    end
    return dir
  end
end
