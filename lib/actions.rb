module Twat
  class Actions
    def tweet(opts)
      # This is all broken, we should know what options we have before this happend
      cf = Config.new
      conf = cf[opts[:account]]

      Twitter.configure do |twit|
        conf.each do |key, value|
          twit.send("#{key}=", value)
        end
      end

      #Twitter.update(tweet)
      puts opts.msg
    end

  end
end
