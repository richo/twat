module Twat
  class Twat
    class << self
      def configure(&block)
        yield config

        # If I understand correctly, I can check over what's
        # happened here?
      end

      def config
        @config ||= Config.new
      end
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

    def polling_interval
      config[:polling_interval] || 60
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

    # I don't know how rubyists feel about method returning something vastly
    # different to what method= accepts, but I think the api makes sense
    def account=(acct)
      if accounts.include?(acct)
        @account = acct
      else
        raise NoSuchAccount
      end
    end

    def account_set?
      !!@account
    end

    def account_name
      if account_set?
        @account
      else
        raise NoDefaultAccount unless config.include?(:default)
        return config[:default].to_sym
      end
    end

    def account
      accounts[account_name]
    end

    def endpoint_name
      account[:endpoint] || :twitter
    end

    def endpoint
      @endpoint ||= Endpoint.new(endpoint_name)
    end

  end
end
