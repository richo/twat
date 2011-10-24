module Twat
  COMMANDS = {}
  class Subcommand

    # A proxy class to represend all of the possible actions that a
    # command may take
    Dir['subcommands/*'].each do |filename|
      require File.join(File.expand_path("../endpoints", __FILE__), File.basename(filename))
    end

    def new(argv)
      unless COMMANDS.include?(argv[1])
        argv.insert(1, "update")
      end

      # There is really no reason why this needs to be explicitly mention
      # in this layout, we could just as easily look for a class in
      # Subcommands:: that matches by name, however this avoids some ugly
      # metaprogramming with minimal overhead, and also leaves the door
      # open for aliasing etc
      COMMANDS[argv[1]].new(argv).run
    end

  end
end
