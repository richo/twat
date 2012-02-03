module Twat::Subcommands
  class Version

    def run
      puts "twat: #{Twat::VERSION}"
    end

  end
  COMMANDS['version'] = Version
end
