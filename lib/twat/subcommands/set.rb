module Twat::Subcommands
  class Set < Base

    def run
      needs_arguments(2)
      k, v = @argv[0..1]
      opts.send(:"#{k}=", v)

      puts "Successfully set #{k} as #{v}"
    end

    def self.usage
      "Usage: twat set option value"
      # TODO Dump available options
    end

  end
  COMMANDS['set'] = Set
end
