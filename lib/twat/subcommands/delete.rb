module Twat::Subcommands
  class Delete < Base

    def run
      if config.accounts.delete(opts[:account])
        config.save!
        puts "Successfully deleted"
      else
        puts "No such account"
      end
    end

    def updateconfig
      config.update!
    end

  end
  COMMANDS['delete'] = Delete
end
