module Twat::Subcommands
  class Version

    def run
      puts "twat: #{Twat::VERSION}"
    end

    def usage
      puts "Usage: twat version"
    end

  end
  COMMANDS['version'] = Version
end
