module Twat::Subcommands
  class Version < Base

    def run
      puts "twat: #{Twat::VERSION}"
    end

    def self.usage
      "Usage: twat version"
    end

  end
  COMMANDS['version'] = Version
end
