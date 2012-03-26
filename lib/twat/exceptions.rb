module Twat
  module Exceptions
    AVAILABLE_ENDPOINTS_ERRMSG = "Available endpoints are #{::Twat::ENDPOINTS.join(", ")}"

    class AlreadyConfigured < Exception; end
    class ArgumentRequired < Exception; end
    class NoSuchAccount < Exception; end
    class NoDefaultAccount < Exception; end
    class NoSuchCommand < Exception; end
    class NoSuchEndpoint < Exception; end
    class NoConfigFile < Exception; end
    class RequiresOptVal < Exception; end
    class Usage < Exception; end
    class InvalidCredentials < Exception; end
    class ConfigVersionIncorrect < Exception; end
    class InvalidSetOpt < Exception; end
    class InvalidBool < Exception; end
    class InvalidInt < Exception; end
    class TweetTooLong < Exception; end
    class NoSuchTweet < Exception; end

    def with_handled_exceptions(opts=nil)
      begin
        yield
      rescue Usage
        opts.usage if opts
      rescue AlreadyConfigured
        puts "Already configured, use add to add more accounts"
      rescue ArgumentRequired
        puts "This command requires an argument"
      rescue NoSuchAccount
        puts "No such account"
      rescue NoDefaultAccount
        puts "No default account configured (try twat set default [account])."
      rescue NoSuchCommand
        puts "No such command"
      rescue NoConfigFile
        puts "No config file, create one with twat -a [user|nick]"
      rescue InvalidSetOpt
        puts "There is no such configurable option"
      rescue RequiresOptVal
        puts "--set must take an option=value pair as arguments"
      rescue InvalidCredentials
        puts "Invalid credentials, try reauthenticating with"
        puts "twat -a ACCOUNT"
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
      rescue NoSuchEndpoint
        puts AVAILABLE_ENDPOINTS_ERRMSG
      end
    end
  end
end
