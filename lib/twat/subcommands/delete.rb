module Twat::Subcommands
  class Delete < Base

    def run
      needs_arguments(1)
      if config.accounts.delete(@argv[0])
        config.save!
        puts "Successfully deleted"
      else
        puts "No such account"
      end
    end

    def usage
      puts "Usage: twat delete ACCOUNTNAME"
    end

    def updateconfig
      config.update!
    end

  end
  COMMANDS['delete'] = Delete
end
