module Twat::Subcommands
  class Add < Base

    def run
      needs_arguments(1)

      endpoint = ::Twat::Endpoint.new(args.endpoint)
      endpoint.authorize_account(@argv[0])
    end

    def self.usage
       "Usage: twat add accountname"
    end

  end
  COMMANDS['add'] = Add
end
