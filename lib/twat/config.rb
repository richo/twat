module Twat
  class Twat
    def configure(&block)
      yield config

      # If I understand correctly, I can check over what's
      # happened here?
    end

    def config
      @config ||= Config.new
    end
  end

  class Config

    def config_path
      @config_path ||= ENV['TWAT_CONFIG'] || "#{ENV['HOME']}/.twatrc"
    end

    def config
      begin
        @config ||= YAML.load_file(config_path)
        validate!(@config)
      rescue Errno::ENOENT
        raise NoConfigFile
      end
    end

    def validate!(conf)
      # TODO Proper checks, instead of a series of hackish checks
      raise ConfigVersionIncorrect unless conf.include?(:accounts)
      conf
    end

    def save!
      File.open(config_path, 'w') do |conf|
        conf.chmod(0600)
        conf.puts(@config.to_yaml)
      end
    end

    def method_missing(meth)
      self[meth]
    end

    def accounts
      return config[:accounts]
    end

    def colors?
      colors = config[:colors] || "true"
      Options.bool_true?(colors)
    end

    def beep?
      beep = config[:beep] || "false"
      Options.bool_true?(beep)
    end

    def default_account
      raise NoDefaultAccount unless config.include?(:default)
      return config[:default].to_sym
    end

    def self.consumer_info
      {
        consumer_key: "jtI2q3Z4NIJAehBG4ntPIQ",
        consumer_secret: "H6vQOGGn9qVJJa9lWyTd2s8ZZRXG4kh3SMfvZ2uxOXE"
      }
    end

    def []=(k, v)
      config[k] = v
    end

    # update! migrates an old config file to the current API
    # it does this by calling a sequence of migration functions in order
    # which rebuild the config in stages, saving and leaving it in a
    # consistent step at each point
    def update!
      Migrate.new.migrate!(config_path)
    end

  end
end
