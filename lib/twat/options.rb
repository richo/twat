module Twat
  class Options

    include ::Twat::Exceptions

    BOOL_TRUE=["yes", "true", "1", "on"]
    BOOL_FALSE=["no", "false", "0", "off"]
    BOOL_VALS = BOOL_TRUE + BOOL_FALSE

    # TODO - Some meta programming to just define boolean values ala
    # attr_accessor

    def self.bool_true?(val)
      BOOL_TRUE.include?(val.to_s.downcase)
    end

    def self.bool_false?(val)
      BOOL_FALSE.include?(val.to_s.downcase)
    end

    def self.bool_valid?(val)
      BOOL_VALS.include?(val.to_s.downcase)
    end

    def self.int_valid?(val)
      !!/^[0-9]+$/.match(val)
    end

    # A set of wrappers around the global config object to set given attributes
    # Catching failures is convenient because of the method_missing? hook
    def method_missing(sym, *args, &block)
      raise InvalidSetOpt, "Options doesn't know about #{sym}"
    end

    def config
      @config ||= Config.new.tap do |n|
        raise NoConfigFile unless n.exists?
      end
    end

    # This is deliberately not abstracted (it could be easily accessed from
    # withing the method_missing method, but that will just lead to nastiness
    # later when I implement colors, for example.
    def default=(value)
      value = value.to_sym
      unless config.accounts.include?(value)
        raise NoSuchAccount
      end

      config[:default] = value
      config.save!
    end

    def colors=(value)
      val = value.to_sym
      raise InvalidBool unless Options.bool_valid?(val)
      config[:colors] = val
      config.save!
    end

    def beep=(value)
      case
      when Options.bool_true?(value)
        config[:beep] = true
      when Options.bool_false?(value)
        config[:beep] = false
      else
        raise InvalidBool
      end
      config.save!
    end

    def polling_interval=(value)
      raise InvalidInt unless Options.int_valid?(value)
      val = value.to_i
      if val < 15 then
        puts "Polling intervals of < 15secs will exceed your daily API requests"
        exit
      else
        config[:polling_interval] = val
        config.save!
      end
    end

  end
end
