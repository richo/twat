module Twat::Subcommands
  class Version

    def run
      puts "twat: #{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_PATCH}"
    end

  end
  COMMANDS['version'] = Version
end
