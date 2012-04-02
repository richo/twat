module Twat
  module Exceptions

    class TwatException < Exception; end

    class Usage < TwatException; end

    class AlreadyConfigured < TwatException
      def msg
        "Already configured, use add to add more accounts"
      end
    end

    class ArgumentRequired < TwatException
      def msg
        "This command requires an argument"
      end
    end
    class NoSuchAccount < TwatException
      def msg
        "No such account"
      end
    end
    class NoDefaultAccount < TwatException
      def msg
        "No default account configured (try twat set default [account])."
      end
    end
    class NoSuchCommand < TwatException
      def msg
        "No such command"
      end
    end
    class NoSuchEndpoint < TwatException
      def msg
        "Available endpoints are #{::Twat::ENDPOINTS.join(", ")}"
      end
    end
    class NoConfigFile < TwatException
      def msg
        "No config file, create one with twat -a [user|nick]"
      end
    end
    class RequiresOptVal < TwatException
      def msg
        "--set must take an option=value pair as arguments"
      end
    end
    class InvalidCredentials < TwatException
      def msg
        ["Invalid credentials, try reauthenticating with",
          "twat -a ACCOUNT"]
      end
    end
    class ConfigVersionIncorrect < TwatException
      def msg
        "Your config file is out of date. Run with --update-config to rememdy"
      end
    end
    class InvalidSetOpt < TwatException
      def msg
        "There is no such configurable option"
      end
    end
    class InvalidBool < TwatException
      def msg
        "Invalid value, valid values are #{Options::BOOL_VALS.join("|")}"
      end
    end
    class InvalidInt < TwatException
      def msg
        "Invalid value, must be an integer"
      end
    end
    class TweetTooLong < TwatException
      def msg
        "Twitter enforces a maximum status length of 140 characters"
      end
    end
    class NoSuchTweet < TwatException
      def msg
        "Specified tweet was not found"
      end
    end

    def with_handled_exceptions(opts=nil)
      begin
        yield
      rescue Usage
        opts.usage if opts
      rescue TwatException => e
        puts e.msg
      end
    end
  end
end
