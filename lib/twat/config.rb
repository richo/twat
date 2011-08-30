require 'ostruct'

module Twat
  class Config #< OpenStruct

    def config_path
      @config_path ||= ENV['TWAT_CONFIG'] || "#{ENV['HOME']}/.twatrc"
    end

    def config
      begin
        @config ||= YAML.load_file(config_path)
      rescue Errno::ENOENT
        @config = default_config
      end
    end

    def save!
      File.open(config_path, 'w') do |conf|
        conf.chmod(0600)
        conf.puts(@config.to_yaml)
      end
    end

    def [](key)
      if key == :default
        accounts[config[:default]]
      else
        raise NoSuchAccount unless accounts.include?(key)
        accounts[key]
      end
    end

    def []=(key, value)
      config[key] = value
    end

    def accounts
      config[:accounts]
    end

    def delete(key)
      config.delete(key)
    end

    def self.consumer_info
      {
        consumer_key: "jtI2q3Z4NIJAehBG4ntPIQ",
        consumer_secret: "H6vQOGGn9qVJJa9lWyTd2s8ZZRXG4kh3SMfvZ2uxOXE"
      }
    end

    def default_config
      {
        accounts: {},
        default: nil
      }
    end

  end
end
