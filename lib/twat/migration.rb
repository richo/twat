module Twat
  class Migrate
    def migrate!(filename)
      @file = filename
      @ran = []
      migration_1 if migration_1?
      if @ran.any?
        Out.put "Successfully ran migrations: #{@ran.join(", ")}"
      else
        Out.put "Already up to date"
      end
    end

    def migration_1?
      current = YAML.load_file(@file)
      return !current.include?(:accounts)
    end

    def migration_1
      new = { accounts: {} }
      default = nil
      current = YAML.load_file(@file)
      current.each do |k, v|
        k = k.to_sym
        if k == :default
          default = v[:oauth_token]
        else
          new[:accounts][k] = v
        end
      end

      new[:accounts].each do |k, v|
        if v[:oauth_token] == default
          new[:default] = k
          break
        end
      end

      save(new)
      @ran << "1"
    end

    def save(cf)
      File.open(@file, 'w') do |conf|
        conf.chmod(0600)
        conf.puts(cf.to_yaml)
      end
    end

  end
end
