%w(base add config delete follow_tag follow list set update update_config finger version).each do |filename|
  require File.join(File.expand_path("../subcommands/#{filename}", __FILE__))
end

module Twat
  class Subcommand

    def self.run
      # This is evilbadscary, but seems like the best approach
      $args = ::Twat::Args.new
      # First, without commands dump user into follow mode
      if ARGV.empty?
        ARGV.insert(0, "follow_tag")

      # Failing that, in the case of invalid commands, assume they want to
      # tweet something.
      # TODO, fuzzy match against the contents of COMMANDS and have a sook if
      # they're close to an actual command
      # FIXME Potentially the absense of a space would suggest that it's just a
      # fucked effort at typing
      elsif !Subcommands::COMMANDS.include?(ARGV[0])
        ARGV.insert(0, "update")
      end

      # There is really no reason why this needs to be explicitly mention
      # in this layout, we could just as easily look for a class in
      # Subcommands:: that matches by name, however this avoids some ugly
      # metaprogramming with minimal overhead, and also leaves the door
      # open for aliasing etc
      Subcommands::COMMANDS[ARGV[0]].new(ARGV[1..-1]).run!
    end

  end
end
