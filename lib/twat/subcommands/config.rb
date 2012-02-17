module Twat::Subcommands
  class Config < Base

    def run
      raise AlreadyConfigured if config_exists

      # Configure
    end

  end
end
