module Twat::Subcommands
  class Add < Base

    def run
      raise ArgumentRequired unless ARGV.length == 2

      # Remove the "add" from the stack
      ARGV.shift

      endpoint = ::Twat::Endpoint.new(args.endpoint)
      endpoint.authorize_account(args[0])
    end

  end
  COMMANDS['add'] = Add
end
