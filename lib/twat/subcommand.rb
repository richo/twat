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

      COMMANDs[argv[1]].new(argv)
    end

  end
end
