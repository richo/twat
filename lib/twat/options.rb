module Twat
  class Options
    BOOL_TRUE=["yes", "true", "1", "on"]
    BOOL_FALSE=["no", "false", "0", "off"]
    BOOL_VALS = BOOL_TRUE + BOOL_FALSE
    def self.bool_true?(val)
      BOOL_TRUE.include?(val.to_s.downcase)
    end

    def self.bool_false?(val)
      BOOL_FALSE.include?(val.to_s.downcase)
    end

    def self.bool_valid?(val)
      BOOL_VALS.include?(val.to_s.downcase)
    end

    # A set of wrappers around the global config object to set given attributes
    # Catching failures is convenient because of the method_missing? hook
    def method_missing(sym, *args, &block)
      puts sym
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

    def colors=(value)
      val = value.to_sym
      raise InvalidBool unless Options.bool_valid?(val)
      config[:colors] = val
      config.save!
    end

  end
end
