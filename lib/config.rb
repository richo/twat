require 'ostruct'

module Twat
  class Config #< OpenStruct

    def config_path
      @config_path ||= ENV['TWAT_CONFIG'] || "#{ENV['HOME']}/.twatrc"
    end

    def config
      @config ||= YAML.load_file(config_path)
    end

    def save!
      File.open(config_path, 'w') do |conf|
        conf.puts(@config.to_yaml)
      end
    end

    def [](key)
      raise NoSuchAccount unless config.include?(key)
      config[key]
    end

    def []=(key, value)
      config[key] = value
    end

    def self.consumer_info
      {
        consumer_key: "jtI2q3Z4NIJAehBG4ntPIQ",
        consumer_secret: "H6vQOGGn9qVJJa9lWyTd2s8ZZRXG4kh3SMfvZ2uxOXE"
      }
    end

  end
end
