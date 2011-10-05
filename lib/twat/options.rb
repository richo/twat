module Twat
  class Options

    # A set of wrappers around the global config object to set given attributes
    # Catching failures is convenient because of the method_missing? hook
    def method_missing(sym, *args, &block)
      raise InvalidSetOpt
    end

    def config
      @config ||= Config.new
    end

    # This is deliberately not abstracted (it could be easily accessed from
    # withing the method_missing method, but that will just lead to nastiness
    # later when I implement colors, for example.
    def default=(value)
      val = value.to_sym
      unless config.accounts.include?(val)
        raise NoSuchAccount
      end

      config[:default] = val
      config.save!
    end

  end
end
