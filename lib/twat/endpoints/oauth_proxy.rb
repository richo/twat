module Twat::Endpoints
  class OauthProxy

    OAUTH_PROXY_HOST = "oauth.psych0.tk"
    OAUTH_PROXY_PORT = 2000

    def sock
      @sock ||= TCPSocket.new OAUTH_PROXY_HOST, OAUTH_PROXY_PORT
    end

    def get_id
      @id ||= sock.recv(128)
    end

    def get_secret
      @secret ||= sock.recv(20)
    end

    def self.proxy
      n = OauthProxy.new
      yield n
    ensure
      n.sock.close
    end

  end
end


