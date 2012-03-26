module Twat
  class Config

    include ::Twat::Exceptions

    def config_path
      @config_path ||= ENV['TWAT_CONFIG'] || "#{ENV['HOME']}/.twatrc"
    end

    def exists?
      File.exist?(config_path)
    end

    def create!
      @config = { accounts: {} }
      save!
    end

    def create_unless_exists!
      begin
        config
      rescue NoConfigFile
        @config = { accounts: {} }
      end
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

    def account_name
      if $args[:account]
        return $args[:account].to_sym
      else
        raise ::Twat::Exceptions::NoDefaultAccount unless config.include?(:default)
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
