%w(base add delete follow list set update user version).each do |filename|
  require File.join(File.expand_path("../subcommands/#{filename}", __FILE__))
end

module Twat
  class Subcommand

    def self.run(argv)
      # First, without commands dump user into follow mode
      if argv.empty?
        argv.insert(0, "follow_stream")

      # Failing that, in the case of invalid commands, assume they want to
      # tweet something.
      # TODO, fuzzy match against the contents of COMMANDS and have a sook if
      # they're close to an actual command
      # FIXME Potentially the absense of a space would suggest that it's just a
      # fucked effort at typing
      elsif !Subcommands::COMMANDS.include?(argv[0])
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
