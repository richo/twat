%w(base add delete follow list set update user version).each do |filename|
  require File.join(File.expand_path("../subcommands/#{filename}", __FILE__))
end

module Twat
  class Subcommand

    # A proxy class to represend all of the possible actions that a
    # command may take
    def self.run(argv)
      unless Subcommands::COMMANDS.include?(argv[0])
        argv.insert(0, "update")
      end

      # There is really no reason why this needs to be explicitly mention
      # in this layout, we could just as easily look for a class in
      # Subcommands:: that matches by name, however this avoids some ugly
      # metaprogramming with minimal overhead, and also leaves the door
      # open for aliasing etc
      Subcommands::COMMANDS[argv[0]].new(argv).run
    end

  end
end
