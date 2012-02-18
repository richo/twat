module Twat
  module Exceptions
    class ArgumentRequired < Exception; end
    class NoSuchAccount < Exception; end
    class NoDefaultAccount < Exception; end
    class NoSuchCommand < Exception; end
    class NoConfigFile < Exception; end
    class RequiresOptVal < Exception; end
    class Usage < Exception; end
    class InvalidCredentials < Exception; end
    class ConfigVersionIncorrect < Exception; end
    class InvalidSetOpt < Exception; end
    class InvalidBool < Exception; end
    class InvalidInt < Exception; end
    class TweetTooLong < Exception; end
  end

  module HandledExceptions
    def with_handled_exceptions(opts)
      begin
        # FIXME
        yield opts
      rescue Usage
        opts.usage
      rescue NoSuchAccount
        puts "No such account"
        opts.usage
      rescue NoDefaultAccount
        puts "No default account configured."
      rescue NoSuchCommand
        puts "No such command"
        opts.usage
      rescue NoConfigFile
        puts "No config file, create one with twat -a [user|nick]"
        opts.usage
      rescue InvalidSetOpt
        puts "There is no such configurable option"
        opts.usage
      rescue RequiresOptVal
        puts "--set must take an option=value pair as arguments"
      rescue InvalidCredentials
        puts "Invalid credentials, try reauthenticating with"
        puts "twat -a #{opts[:account]}"
      rescue ConfigVersionIncorrect
        puts "Your config file is out of date. Run with --update-config to rememdy"
      rescue InvalidBool
        puts "Invalid value, valid values are #{Options::BOOL_VALID.join("|")}"
      rescue InvalidInt
        puts "Invalid value, must be an integer"
      rescue Errno::ECONNRESET
        puts "Connection was reset by third party."
      rescue TweetTooLong
        puts "Twitter enforces a maximum status length of 140 characters"
      end
    end
  end
end
