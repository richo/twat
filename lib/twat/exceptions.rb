module Twat
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
  class InvalidColor < Exception; end
  class TweetTooLong < Exception; end

  module HandledExceptions
    def with_handled_exceptions(opts)
      begin
        # FIXME
        yield opts
      rescue Usage
        opts.usage
      rescue NoSuchAccount
        Out.put "No such account"
        opts.usage
      rescue NoDefaultAccount
        Out.put "No default account configured."
      rescue NoSuchCommand
        Out.put "No such command"
        opts.usage
      rescue NoConfigFile
        Out.put "No config file, create one with twat -a [user|nick]"
        opts.usage
      rescue InvalidSetOpt
        Out.put "There is no such configurable option"
        opts.usage
      rescue RequiresOptVal
        Out.put "--set must take an option=value pair as arguments"
      rescue InvalidCredentials
        Out.put "Invalid credentials, try reauthenticating with"
        Out.put "twat -a #{opts[:account]}"
      rescue ConfigVersionIncorrect
        Out.put "Your config file is out of date. Run with --update-config to rememdy"
      rescue InvalidBool
        Out.put "Invalid value, valid values are #{Options::BOOL_VALID.join("|")}"
      rescue InvalidInt
        Out.put "Invalid value, must be an integer"
      rescue Errno::ECONNRESET
        Out.put "Connection was reset by third party."
      rescue TweetTooLong
        Out.put "Twitter enforces a maximum status length of 140 characters"
      end
    end
  end
end
