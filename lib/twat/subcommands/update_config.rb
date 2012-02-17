module Twat::Subcommands
  class UpdateConfig < Base

    def run

      config.update_config

    end

  end
  COMMANDS['update_config'] = UpdateConfig
end
