module Twat::Subcommands
  class Follow < Base

    def run
      needs_arguments(1)
      auth!

      Twitter.follow(@argv[0])
    end

    def self.usage
      "Usage: twat follow USERNAME"
    end

  end
  COMMANDS['follow'] = Follow
end

