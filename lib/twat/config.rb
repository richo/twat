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
      rescue Errno::ENOENT
        raise NoConfigFile
      end
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

    def default_account
      raise NoDefaultAccount unless config.include?(:default)
      raise NoSuchAccount unless config[:accounts].include(config[:default])
      return config[:accounts][config[:default]]
    end

    def self.consumer_info
      {
        consumer_key: "jtI2q3Z4NIJAehBG4ntPIQ",
        consumer_secret: "H6vQOGGn9qVJJa9lWyTd2s8ZZRXG4kh3SMfvZ2uxOXE"
      }
    end

  end
end
