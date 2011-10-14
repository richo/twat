module Twat
  def twitter
    @twitter ||= if config.account[:endpoint]
                   Twitter.new(:endpoint => config.account[:endpoint])
                 else
                   Twitter.new
                 end
  end
end
