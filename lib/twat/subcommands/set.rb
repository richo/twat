module Twat::Subcommands
  class Set < Base
    def run
      k, v = opts[:optval].split("=")
      raise RequiresOptVal unless v
      options = Options.new
      options.send(:"#{k}=", v)

      puts "Successfully set #{k} as #{v}"
    end
  end
  COMMANDS['set'] = Set
end
