module Twat::Subcommands
  class Config < Base

    def run
      raise AlreadyConfigured if config.exists?
      config.create!
    end

    def self.usage
      "Usage: twat config"
    end

  end
  COMMANDS['config'] = Config
end
